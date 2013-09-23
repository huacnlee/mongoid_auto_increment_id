This gem for change Mongoid id field as Integer like MySQL.

Idea from MongoDB document: [How to Make an Auto Incrementing Field](http://www.mongodb.org/display/DOCS/How+to+Make+an+Auto+Incrementing+Field)

## Status

- [![Gem Version](https://badge.fury.io/rb/mongoid_auto_increment_id.png)](https://rubygems.org/gems/mongoid_auto_increment_id)
- [![CI Status](https://api.travis-ci.org/huacnlee/mongoid_auto_increment_id.png)](http://travis-ci.org/huacnlee/mongoid_auto_increment_id)

## Installation

```ruby
# Support Mongoid 3.0.0 - 4.0.0+
gem 'mongoid_auto_increment_id', "0.6.0"
```

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
