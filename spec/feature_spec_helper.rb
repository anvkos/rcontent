ENV['RACK_ENV'] = 'test'
require './app'
require 'rack/test'
require 'database_cleaner'
require 'factory_girl'

def app
  App
end

FactoryGirl.definition_file_paths = %w(./factories ./test/factories ./spec/factories)
FactoryGirl.find_definitions

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.include FactoryGirl::Syntax::Methods

  config.before(:suite) do
    DatabaseCleaner[:sequel, { connection: DB.connection }]
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner[:sequel].strategy = :transaction
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
