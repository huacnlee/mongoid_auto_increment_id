This gem for change Mongoid id field as Integer like MySQL.

Idea from MongoDB document: [How to Make an Auto Incrementing Field](http://www.mongodb.org/display/DOCS/How+to+Make+an+Auto+Incrementing+Field)

## Status

[![CI Status](https://secure.travis-ci.org/huacnlee/mongoid_auto_increment_id.png)](http://travis-ci.org/huacnlee/mongoid_auto_increment_id)

## Installation

    # for Mongoid 2.2.x
    gem 'mongoid_auto_increment_id', "0.2.2" 
    # for Mongoid 2.3.x
    gem 'mongoid_auto_increment_id', "0.3.0" 


## REQUIREMENTS

* Mongoid 2.2.0+

## USAGE

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


## Performance

with `mongoid_auto_increment_id`:

          user     system      total        real
    Generate 1  0.010000   0.000000   0.010000 (  0.006182)
    Post current: 1

    Generate 100  0.130000   0.010000   0.140000 (  0.406619)
    Post current: 101

    Generate 10,000  10.160000   0.560000  10.720000 ( 12.518690)
    Post current: 10101
    
without:

          user     system      total        real
    Generate 1  0.000000   0.000000   0.000000 (  0.171523)
    Post current: 1

    Generate 100  0.110000   0.000000   0.110000 (  0.129670)
    Post current: 101

    Generate 10,000  9.340000   0.470000   9.810000 ( 11.233426)
    Post current: 10101
