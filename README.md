This gem for change Mongoid id field as Integer like MySQL.

Idea from MongoDB document: [How to Make an Auto Incrementing Field](http://www.mongodb.org/display/DOCS/How+to+Make+an+Auto+Incrementing+Field)

# Installation

```ruby
gem 'mongoid_auto_increment_id'
```

# REQUIREMENTS

* Mongoid 2.2.0+

# USAGE

```shell
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
