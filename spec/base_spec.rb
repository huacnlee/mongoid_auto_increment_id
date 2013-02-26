require "spec_helper"

describe "Mongoid::AutoIncrementId" do
  after do
    Post.delete_all
    Tag.delete_all
    User.delete_all
    Log.delete_all
  end
  
  it "new record Id will be nil" do
    Post.new.id.should == nil
  end

  it "does Id start from 1" do
    Post.create(:title => "Foo bar").id.should == 1
    User.create(:email => "huacnlee@gmail.com").id.should == 1
  end

  it "does can return Integer Id when create/save" do
    Post.create(:title => "Foo bar").id.should be_a_kind_of(Integer)
    p1 = Post.new(:title => "Foo bar")
    p1.save
    p1.id.should be_a_kind_of(Integer)
  end

  it "it does generated ids was incremented and no repeat" do
    p1 = Post.create(:title => "Foo bar")
    p2 = Post.create(:title => "Bar foo")
    p3 = Post.create(:title => "Hello world.")
    (p2.id - 1).should == p1.id
    (p3.id - 2).should == p1.id
    p3.destroy
    p4 = Post.create(:title => "Create Hellow world again.")
    (p4.id - 2).should == p2.id
  end

  it "does return nil id when Model.new" do
    Post.new.id.should == nil
    Post.new._id.should == nil
  end

  it "does can find data by String and Integer id" do
    post = Post.create(:title => "Foo bar")
    Post.find(post.id.to_i).should == post
    Post.find(post.id.to_s).should == post
  end

  it "does can find by where :_id" do
    post1 = Post.create(:title => "Foo bar")
    post2 = Post.create(:title => "Bar Foo")
    post3 = Post.create(:title => "Foo Foo")
    Post.where(:_id => post1.id).first.title == "Foo Bar"
    Post.where(:_id => post2.id).first.title == "Bar Foo"
  end

  it "does 1..N working fine" do
    user1 = User.new(:email => "huacnlee@gmail.com",:name => "Jason Lee")
    user1.save
    post1 = Post.create(:title => "Foo bar", :user_id => user1.id)
    post1.user.email.should == user1.email
    User.first.posts.first.id.should == post1.id
    user1.posts << Post.create(:title => "Bar foo")
    user1.save
    User.first.posts.count.should == 2
  end

  it "does 1..1 working fine." do
    post = Post.create(:title => "Foo bar")
    post_ext = post.build_post_ext(:body_ext => "Bar foo")
    post_ext.save
    Post.first.post_ext.body_ext.should == "Bar foo"
    post_ext.post.should == post
    post_ext.post_id.should == post.id
  end

  it "does N..N working find." do
    post = Post.create(:title => "Foo bar")
    post.tags.create(:name => "Ruby")
    post.tags.create(:name => "Rails")
    post.tags.create(:name => "Python")
    Post.first.tags.count.should == 3
    post.tags << Tag.create(:name => "Django")
    Post.first.tags.count.should == 4
    Tag.first.posts.first.id.should == post.id
    Tag.first.id.should be_a_kind_of(Integer)
  end

  it "does embedded_in/embeds_many working fine." do
    post = Post.create(:title => "Foo bar")
    post.comments.create(:author => "Monster", :body => "This is comment.")
    post.comments.create(:author => "Do do", :body => "Thanks.")
    Post.first.comments.count.should == 2
    Post.first.comments.first.id.should be_a_kind_of(Integer)
  end

  it "does descendant class can working" do
    userlog = UserLog.create(:title => "test user log")
    userlog.errors.count.should == 0
    taglog = TagLog.create(:title => "test tag log")
    taglog.errors.count.should == 0
    userlog._type.should == "UserLog"
    taglog._type.should == "TagLog"
    UserLog.count.should == 1
    TagLog.count.should == 1
    Log.count.should == 2
    Log.where(:title => "test user log").count.should == 1
    Log.where(:title => "test user log").first._type.should == "UserLog"
    Log.where(:title => "test tag log").count.should == 1
    Log.where(:title => "test tag log").first._type.should == "TagLog"
  end
end