#--
###############################################################################
#                                                                             #
# added_methods - watch for added methods and record them.                    #
#                                                                             #
# Copyright (C) 2007-2009 Jens Wille                                          #
#                                                                             #
# Authors:                                                                    #
#     Jens Wille <jens.wille@uni-koeln.de>                                    #
#                                                                             #
# added_methods is free software; you can redistribute it and/or modify it    #
# under the terms of the GNU General Public License as published by the Free  #
# Software Foundation; either version 3 of the License, or (at your option)   #
# any later version.                                                          #
#                                                                             #
# added_methods is distributed in the hope that it will be useful, but        #
# WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY  #
# or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License     #
# for more details.                                                           #
#                                                                             #
# You should have received a copy of the GNU General Public License along     #
# with added_methods. If not, see <http://www.gnu.org/licenses/>.             #
#                                                                             #
###############################################################################
#++

begin
  require 'ruby2ruby'
rescue LoadError
end

require 'added_methods/added_method'

# TODO:
#
# - multi-line statements in irb w/o ruby2ruby? (=> extract_source)
# - polishing!

module AddedMethods

  extend self

  HISTFILENAME = '(Readline::HISTORY)'.freeze unless const_defined?(:HISTFILENAME)

  def init(regexp = nil, klasses = [], &block)
    init_script_lines
    patch_readline_history

    define_callback(:__init, regexp, klasses, &block) if regexp
    install_callbacks
  end

  def callbacks
    init_callbacks
    CALLBACKS
  end

  def callback(*args, &inner_block)
    callback_args = [identify_added_method(*args << caller), caller, inner_block]
    callbacks.each { |name, callback| callback[*callback_args] }
  end

  def define_callback(name, regexp = //, klasses = [], &outer_block)
    raise TypeError, "wrong argument type #{name.class} (expected Symbol)" unless name.is_a?(Symbol)
    raise "callback with name #{name} already exists" if callbacks.assoc(name)

    raise TypeError, "wrong argument type #{regexp.class} (expected Regexp)" unless regexp.is_a?(Regexp)
    raise TypeError, "wrong argument type #{klasses.class} (expected container object)" unless klasses.respond_to?(:empty?) && klasses.respond_to?(:include?)

    callbacks << [name, lambda { |am, callstack, inner_block|
      method, klass = am.name, am.klass

      return if %w[method_added singleton_method_added].include?(method)

      return unless klasses.empty? || klasses.include?(klass.to_s)
      return unless method =~ regexp

      if outer_block || inner_block
        outer_block[am] if outer_block
        inner_block[am] if inner_block
      else
        msg = "[#{am.base}] Adding #{'singleton ' if am.singleton?}method #{klass}##{method}"

        msg << if irb?(callstack)
          " in (irb:#{IRB.conf[:MAIN_CONTEXT].instance_variable_get(:@line_no)})"
        else
          " at #{where(callstack)}"
        end

        puts msg
      end
    }]
  end

  def remove_callback(name)
    callbacks.delete_if { |n, _| n == name }
  end

  def replace_callback(name, regexp = nil, klasses = [], &outer_block)
    remove_callback(name)
    define_callback(name, regexp, klasses, &outer_block)
  end

  def install_callbacks(bases = [Object, Class, Module, Kernel])
    bases.each { |base|
      [base, singleton_class(base)].each { |b|
        b.send(:define_method, :method_added)           { |id| AddedMethods.callback(b, self, id, false) }
        b.send(:define_method, :singleton_method_added) { |id| AddedMethods.callback(b, self, id, true)  }
      }
    }
  end

  def all_methods
    init_all_methods
    ALL_METHODS
  end

  def find(conditions = {})
    conditions = conditions.dup

    class_condition = conditions.delete(:class)
    file_condition  = conditions.delete(:file)

    results = []

    all_methods.each { |klass, files|
      if class_condition
        next unless class_condition.is_a?(Array) ? class_condition.include?(klass) : klass == class_condition
      end

      files.each { |file, entries|
        if file_condition
          next unless file_condition.is_a?(Regexp) ? file =~ file_condition : file == file_condition
        end

        entries.each { |am|
          results << am if conditions.all? { |key, value|
            case value
              when Array, Range then value.include?(am[key])
              when Regexp       then value =~ am[key].to_s
              else                   value == am[key]
            end
          }
        }
      }
    }

    results
  end

  def find_by_class(*classes)
    conditions = classes.last.is_a?(Hash) ? classes.pop : {}
    find(conditions.merge(:class => classes))
  end

  def find_by_name(*names)
    conditions = names.last.is_a?(Hash) ? names.pop : {}
    find(conditions.merge(:name => names.map { |m| m.to_s }))
  end

  def find_one_by_name_or_class(name_or_class, conditions = {})
    (name_or_class.is_a?(Class) ?
      find_by_class(name_or_class) :
      find_by_name(name_or_class)
    ).last
  end

  alias_method :[], :find_one_by_name_or_class

  private

  def singleton_class(klass = self)
    class << klass; self; end
  end

  def init_script_lines
    unless Object.const_defined?(:SCRIPT_LINES__)
      Object.const_set(:SCRIPT_LINES__, {})
    end
  end

  def init_callbacks
    unless const_defined?(:CALLBACKS)
      const_set(:CALLBACKS, [])
      define_callback(:__default, //, [], &added_method_callback)
    end
  end

  def init_all_methods
    unless const_defined?(:ALL_METHODS)
      const_set(:ALL_METHODS, Hash.new { |h, k|
        h[k] = Hash.new { |i, j| i[j] = [] }
      })
    end
  end

  def patch_readline_history
    return unless have_readline_history?
    return if Readline::HISTORY.respond_to?(:_added_methods_original_push)

    class << Readline::HISTORY
      alias_method :_added_methods_original_push, :push

      def push(l)
        (SCRIPT_LINES__[HISTFILENAME] ||= Readline::HISTORY.to_a) << l
        _added_methods_original_push(l)
      end

      alias_method :<<, :push
    end
  end

  def have_readline_history?
    Object.const_defined?(:Readline) && Readline.const_defined?(:HISTORY)
  end

  def defined_in_irb?(callstack)
    callstack = callstack.dup

    callstack.shift  # ignore immediate caller
    callstack.reject! { |c| c =~ /\(irb\):|:in `irb_binding'/ }
    callstack.pop if callstack.last =~ %r{/irb/workspace\.rb:}

    callstack.empty?
  end

  def irb?(callstack)
    have_readline_history? && defined_in_irb?(callstack)
  end

  def where(callstack, default = '(none):0')
    callstack.find { |i| i !~ /:in `.*'/ } || callstack[1] || default
  end

  def added_method_callback
    lambda { |am| add_method(am) }
  end

  def add_method(am)
    am = AddedMethod.new(am) unless am.is_a?(AddedMethod)
    all_methods[am.klass][am.file] << am
  end

  def identify_added_method(base, klass, id, singleton, callstack)
    am = {
      :base      => base,
      :class     => klass,
      :name      => id.id2name,
      :singleton => singleton
    }

    if irb?(callstack)
      am.update(
        :file => HISTFILENAME,
        :line => Readline::HISTORY.size,
        :def  => begin Readline::HISTORY[-1] rescue IndexError end
      )
    else
      file, line, _ = where(callstack).split(':')
      line = line.to_i

      am.update(
        :file => file,
        :line => line,
        :def  => (SCRIPT_LINES__[file] || [])[line - 1]
      )
    end

    AddedMethod.new(am)
  end

end
