require %q{lib/added_methods/version}

begin
  require 'hen'

  Hen.lay! {{
    :rubyforge => {
      :project => '', #%q{added_methods},
      :package => %q{added_methods},
      :rdoc_dir => nil
    },

    :gem => {
      :version      => AddedMethods::VERSION,
      :summary      => %q{Watches for added methods and records them.},
      :homepage     => 'http://github.com/blackwinter/added_methods', #%q{http://added_methods.rubyforge.org/},
      :files        => FileList['lib/**/*.rb'].to_a,
      :extra_files  => FileList['[A-Z]*'].to_a,
      :dependencies => %w[]
    }
  }}
rescue LoadError
  abort "Please install the 'hen' gem first."
end

### Place your custom Rake tasks here.
