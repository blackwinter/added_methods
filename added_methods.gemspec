# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{added_methods}
  s.version = "0.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jens Wille"]
  s.date = %q{2011-04-29}
  s.description = %q{Watches for added methods and records them.}
  s.email = %q{jens.wille@uni-koeln.de}
  s.extra_rdoc_files = ["README", "COPYING", "ChangeLog"]
  s.files = ["lib/added_methods/added_method.rb", "lib/added_methods/init.rb", "lib/added_methods/version.rb", "lib/added_methods.rb", "README", "ChangeLog", "Rakefile", "COPYING", "spec/spec.opts", "spec/added_methods_spec.rb", "spec/spec_helper.rb"]
  s.homepage = %q{http://github.com/blackwinter/added_methods}
  s.rdoc_options = ["--charset", "UTF-8", "--title", "added_methods Application documentation (v0.1.1)", "--main", "README", "--line-numbers", "--all"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.7.2}
  s.summary = %q{Watches for added methods and records them.}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
