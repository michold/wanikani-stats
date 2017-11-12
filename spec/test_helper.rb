ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

RSpec.configure do |config|
  # config.include FactoryBot::Syntax::Methods
end
