require 'test/unit'
require File.expand_path('../helper', __FILE__)
require File.expand_path('../../lib/rokko', __FILE__)

Dir[File.expand_path('../test_*.rb', __FILE__)].each {|f| require f}