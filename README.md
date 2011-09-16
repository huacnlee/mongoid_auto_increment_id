This gem for change Mongoid id field as Integer like MySQL.

Idea from MongoDB document: [How to Make an Auto Incrementing Field](http://www.mongodb.org/display/DOCS/How+to+Make+an+Auto+Incrementing+Field)

# Installation

```ruby
gem 'mongoid_auto_increment_id'
```

# USAGE

```shell
ruby > post = Post.new(:title => "Hello world")
 => #<Post _id: , _type: nil, title: "Hello world", body: nil> 
ruby > post.save
 => true
ruby > post.inspect
 => "#<Post _id: 6, _type: nil, title: \"Hello world\", body: nil>" 
```