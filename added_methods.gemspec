# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{added_methods}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jens Wille"]
  s.date = %q{2009-03-27}
  s.description = %q{Watches for added methods and records them.}
  s.email = %q{jens.wille@uni-koeln.de}
  s.extra_rdoc_files = ["COPYING", "ChangeLog", "README"]
  s.files = ["lib/added_methods.rb", "lib/added_methods/version.rb", "lib/added_methods/init.rb", "Rakefile", "COPYING", "ChangeLog", "README"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/blackwinter/added_methods}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "added_methods Application documentation", "--main", "README", "--charset", "UTF-8", "--all"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Watches for added methods and records them.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
