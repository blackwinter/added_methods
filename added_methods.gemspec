# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "added_methods"
  s.version = "0.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jens Wille"]
  s.date = "2013-07-15"
  s.description = "Watches for added methods and records them."
  s.email = "jens.wille@gmail.com"
  s.extra_rdoc_files = ["README", "COPYING", "ChangeLog"]
  s.files = ["lib/added_methods.rb", "lib/added_methods/added_method.rb", "lib/added_methods/init.rb", "lib/added_methods/version.rb", "COPYING", "ChangeLog", "README", "Rakefile", "spec/added_methods_spec.rb", "spec/spec.opts", "spec/spec_helper.rb"]
  s.homepage = "http://github.com/blackwinter/added_methods"
  s.licenses = ["AGPL"]
  s.rdoc_options = ["--charset", "UTF-8", "--line-numbers", "--all", "--title", "added_methods Application documentation (v0.1.1)", "--main", "README"]
  s.require_paths = ["lib"]
  s.rubygems_version = "2.0.5"
  s.summary = "Watches for added methods and records them."
end
