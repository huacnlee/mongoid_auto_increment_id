require 'rubygems'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'active_support/all'
require "mongoid"
require "mocha"
require "mongoid_auto_increment_id"
require "uri"

mongoid_config = YAML.load_file(File.join(File.dirname(__FILE__),"mongoid.yml"))['test']
Mongoid.configure do |config|
  if !mongoid_config['uri'].blank?
    config.master = Mongo::Connection.from_uri(mongoid_config['uri']).db(mongoid_config['uri'].split('/').last)
  else
    config.master = Mongo::Connection.new(mongoid_config['host'], mongoid_config['port']).db(mongoid_config['database'])
  end
end

require "models"

RSpec.configure do |config|
  config.mock_with :mocha
  config.after :suite do
    Mongoid.master.collections.select {|c| c.name !~ /system/ }.each(&:drop)
  end
end