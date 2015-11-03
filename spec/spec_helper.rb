require 'rubygems'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require "mocha"
require "mongoid_auto_increment_id"
require "uri"

# These environment variables can be set if wanting to test against a database
# that is not on the local machine.
ENV["MONGOID_SPEC_HOST"] ||= "localhost"
ENV["MONGOID_SPEC_PORT"] ||= "27017"

# These are used when creating any connection in the test suite.
HOST = ENV["MONGOID_SPEC_HOST"]
PORT = ENV["MONGOID_SPEC_PORT"].to_i

def database_id
  ENV["CI"] ? "mongoid_aii_#{Process.pid}" : "mongoid_aii_test"
end

MONGOID_CONFIG = {
  clients: {
    default: {
      database: database_id,
      hosts: [ "#{HOST}:#{PORT}" ]
    }
  }
}


# Set the database that the spec suite connects to.
Mongo::Logger.logger.level = Logger::WARN
Mongoid.configure do |config|
  config.load_configuration(MONGOID_CONFIG)
end

require "models"

RSpec.configure do |config|
  config.mock_with :mocha
  config.after :suite do
    Mongoid.purge!
  end
end
