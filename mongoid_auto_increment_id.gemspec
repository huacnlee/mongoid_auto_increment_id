# encoding: utf-8
$:.push File.expand_path("../lib", __FILE__)

require 'mongoid_auto_increment_id'

Gem::Specification.new do |s|
  s.name        = "mongoid_auto_increment_id"
  s.version     = Mongoid::AutoIncrementId::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jason Lee"]
  s.email       = ["huacnlee@gmail.com"]
  s.homepage    = "https://github.com/huacnlee/mongoid_auto_increment_id"
  s.summary     = %q{Override id field with MySQL like auto increment for Mongoid}
  s.description = %q{This gem for change Mongoid id field as Integer like MySQL.}
  s.files        = Dir.glob("lib/**/*") + %w(README.md)
  s.require_path = 'lib'

  s.add_dependency "mongoid", ["> 5.0.0","< 6.0.0"]
end
