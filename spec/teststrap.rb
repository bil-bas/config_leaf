require 'rspec/autorun'
require 'rr'

RSpec.configure do |config|
  config.mock_framework = :rr
end

require File.expand_path('../../lib/config_leaf', __FILE__)