$:.unshift('lib') unless $:[0] == 'lib'

require 'added_methods'
AddedMethods.init
