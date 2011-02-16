require File.expand_path(%q{../lib/added_methods/version}, __FILE__)

begin
  require 'hen'

  Hen.lay! {{
    :gem => {
      :name     => %q{added_methods},
      :version  => AddedMethods::VERSION,
      :summary  => %q{Watches for added methods and records them.},
      :author   => %q{Jens Wille},
      :email    => %q{jens.wille@uni-koeln.de},
      :homepage => :blackwinter
    }
  }}
rescue LoadError => err
  warn "Please install the `hen' gem. (#{err})"
end
