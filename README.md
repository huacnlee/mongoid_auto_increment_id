This gem for change Mongoid id field as Integer like MySQL.

Idea from MongoDB document: [How to Make an Auto Incrementing Field](http://www.mongodb.org/display/DOCS/How+to+Make+an+Auto+Incrementing+Field)

## Status

- [![Gem Version](https://badge.fury.io/rb/mongoid_auto_increment_id.svg)](https://rubygems.org/gems/mongoid_auto_increment_id)
- [![CI Status](https://api.travis-ci.org/huacnlee/mongoid_auto_increment_id.svg)](http://travis-ci.org/huacnlee/mongoid_auto_increment_id)

## Installation

```ruby
# Mongoid 3.0.x
gem 'mongoid_auto_increment_id', "0.6.1"
# Mongoid 3.1.x
gem 'mongoid_auto_increment_id', "0.6.2"
# Mongoid 4.x
gem 'mongoid_auto_increment_id', "0.7.0"
# Mongoid 5.x
gem 'mongoid_auto_increment_id', "0.8.0"
```

## Configure

If you want use sequence cache to reduce MongoDB write, you can enable cache:

config/initializes/mongoid_auto_increment_id.rb

```ruby
# Mongoid::AutoIncrementId.cache_store = ActiveSupport::Cache::MemoryStore.new
# First call will generate 200 ids and caching in cache_store
# Then the next 199 ids will return from cache_store
# Until 200 ids used, it will generate next 200 ids again.
Mongoid::AutoIncrementId.seq_cache_size = 200
```

> NOTE: mongoid_auto_increment_id is very fast in default config, you may don't need enable that, if you project not need insert huge rows in a moment.

## USAGE

```ruby
ruby > post = Post.new(:title => "Hello world")
 => #<Post _id: , _type: nil, title: "Hello world", body: nil>
ruby > post.save
 => true
ruby > post.inspect
 => "#<Post _id: 6, _type: nil, title: \"Hello world\", body: nil>"
ruby > Post.find("6")
 => "#<Post _id: 6, _type: nil, title: \"Hello world\", body: nil>"
ruby > Post.find(6)
 => "#<Post _id: 6, _type: nil, title: \"Hello world\", body: nil>"
ruby > Post.desc(:_id).all.to_a.collect { |row| row.id }
 => [20,19,18,17,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1]
```


## Performance

This is a branchmark results run in MacBook Pro Retina.

with `mongoid_auto_increment_id`:

```
       user     system      total        real
Generate 1  0.000000   0.000000   0.000000 (  0.004301)
Post current: 1

Generate 100  0.070000   0.000000   0.070000 (  0.091638)
Post current: 101

Generate 10,000  7.300000   0.570000   7.870000 (  9.962469)
Post current: 10101
```

without:

```
       user     system      total        real
Generate 1  0.000000   0.000000   0.000000 (  0.002569)
Post current: 1

Generate 100  0.050000   0.000000   0.050000 (  0.052045)
Post current: 101

Generate 10,000  5.220000   0.170000   5.390000 (  5.389207)
Post current: 10101
```
