$:.unshift('lib') unless $:[0] == 'lib'

require 'added_methods'
AddedMethods.init

RSpec.configure { |config|
  config.expect_with(:rspec) { |c| c.syntax = [:should, :expect] }
}
