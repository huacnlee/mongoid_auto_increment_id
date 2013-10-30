class Post
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title
  field :body

  belongs_to :user
  has_and_belongs_to_many :tags
  embeds_many :comments
  has_one :post_ext
end

class Comment
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :author
  field :body
  
  embedded_in :post
end

class Log
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :title
end

class TagLog < Log
end

class UserLog < Log
end

class Tag
  include Mongoid::Document
  
  field :name
  has_and_belongs_to_many :posts
end

class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :email
  field :password
  field :name
  
  has_many :posts
end

class PostExt
  include Mongoid::Document
  
  belongs_to :post
  field :body_ext
end
