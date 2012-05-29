This gem for change Mongoid id field as Integer like MySQL.

Idea from MongoDB document: [How to Make an Auto Incrementing Field](http://www.mongodb.org/display/DOCS/How+to+Make+an+Auto+Incrementing+Field)

## Status

[![CI Status](https://secure.travis-ci.org/huacnlee/mongoid_auto_increment_id.png)](http://travis-ci.org/huacnlee/mongoid_auto_increment_id)

## Installation

    # for Mongoid 2.2.x
    gem 'mongoid_auto_increment_id', "0.2.2"
    # for Mongoid 2.3.x
    gem 'mongoid_auto_increment_id', "0.3.1"
    # for Mongoid 2.4.x
    gem 'mongoid_auto_increment_id', "0.4.0"
    # for Mongoid 3.0.x
    gem 'mongoid_auto_increment_id', "0.5.0"

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

```
       user     system      total        real
Generate 1  0.010000   0.000000   0.010000 (  0.004616)
Post current: 1

Generate 100  0.110000   0.010000   0.120000 (  0.161558)
Post current: 101

Generate 10,000 12.460000   1.710000  14.170000 ( 17.940543)
Post current: 10101
```

without:

```
       user     system      total        real
Generate 1  0.000000   0.000000   0.000000 (  0.004660)
Post current: 1

Generate 100  0.090000   0.000000   0.090000 (  0.091748)
Post current: 101

Generate 10,000  7.710000   0.950000   8.660000 (  8.660268)
Post current: 10101
```
