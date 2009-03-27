#--
###############################################################################
#                                                                             #
# A component of added_methods, the added method watcher.                     #
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

module AddedMethods

  class AddedMethod

    attr_accessor :base, :klass, :name, :singleton, :file, :line, :def, :time

    def initialize(args = {})
      self.time = Time.now

      args.each { |key, value|
        send("#{key}=", value)
      }
    end

    alias_method 'class=',    'klass='
    alias_method :singleton?, :singleton

    def [](key)
      send(key.to_sym == :class ? :klass : key)
    end

    def source
      @source ||= extract_source
    end

    def r2r_source
      @r2r_source ||= extract_source_from_r2r
    end

    def extract_source(num_lines = nil)
      lines = extract_source_from_script_lines(num_lines)

      # try to make sure we correctly extracted the method
      # definition, otherwise try to get it from Ruby2Ruby
      if lines && lines.first =~ /\b#{name}\b/
        lines
      else
        extract_source_from_r2r || lines
      end
    end

    def to_s
      str = "# File #{file}, line #{line}"

      case lines = source
        when Array
          num   = line - 1
          width = (num + lines.size).to_s.length

          lines.map! { |l| "%0#{width}d: %s" % [num += 1, l] }

          "#{' ' * width}  #{str}\n#{lines}"
        when String
          "#{str}#{lines}"
        else
          str
      end
    end

    private

    def extract_source_from_script_lines(num_lines = nil)
      return unless Object.const_defined?(:SCRIPT_LINES__)
      return unless script_lines = SCRIPT_LINES__[file]

      start, from, to = line - 1, line, script_lines.size - 1

      # suppose we're already in a block
      in_block = 1

      num_lines ||= case definition = script_lines[start]
        # def ... end, or do ... end style block
        when /\b(?:def|do)\b/
          definition =~ /\bend\b/ ? 1 : begin
            from.upto(to) { |i|
              case line = script_lines[i]
                when /[^;\s]\s+(?:if|unless)\b/
                  # probably postfix conditional, ignore
                when /\b(?:if|unless|while|until|def|do)\b/
                  in_block += 1
                when /\bend\b/
                  in_block -= 1
              end

              break i - start + 1 if in_block.zero?
            }
          end
        # { ... } style block
        when /\bdefine_method\b/
          from.upto(to) { |i|
            line = script_lines[i]

            in_block += line.count('{')
            in_block -= line.count('}')

            break i - start + 1 if in_block.zero?
          }
        else
          1
      end

      script_lines[start, num_lines]
    end

    # Use Ruby2Ruby as a last resort. But note that it only
    # ever finds the *latest*, i.e. currently active, method
    # definition, not necessarily the one we're looking for.
    def extract_source_from_r2r
      if Object.const_defined?(:Ruby2Ruby)
        " [R2R]\n#{Ruby2Ruby.translate(klass, name)}"
      end
    end

  end

end
