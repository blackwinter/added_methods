require_relative 'lib/added_methods/version'

begin
  require 'hen'

  Hen.lay! {{
    gem: {
      name:     %q{added_methods},
      version:  AddedMethods::VERSION,
      summary:  %q{Watches for added methods and records them.},
      author:   %q{Jens Wille},
      email:    %q{jens.wille@gmail.com},
      license:  %q{AGPL-3.0},
      homepage: :blackwinter,

      required_ruby_version: '>= 1.9.3'
    }
  }}
rescue LoadError => err
  warn "Please install the `hen' gem. (#{err})"
end
