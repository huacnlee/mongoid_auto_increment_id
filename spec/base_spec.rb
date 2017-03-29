require "spec_helper"

describe "Mongoid::AutoIncrementId" do
  describe 'Base test' do
    before do
      Mongoid.purge!
    end

    after do
      Post.delete_all
      Tag.delete_all
      User.delete_all
      Log.delete_all
    end
  
    it "new record Id will be integer" do
      expect(Post.new.id).to be_a Integer
    end

    it "does Id start from 1" do
      expect(Post.create(:title => "Foo bar").id).to eq 1
      expect(Post.create(:title => "Foo bar").id).to eq 2
      expect(User.create(:email => "huacnlee@gmail.com").id).to eq 1
    end

    it "does can return Integer Id when create/save" do
      expect(Post.create(:title => "Foo bar").id).to be_a(Integer)
      p1 = Post.new(:title => "Foo bar")
      expect {
        p1.save
      }.to change(Post, :count).by(1)
      expect(p1.id).to be_a(Integer)
    end

    it "it does generated ids was incremented and no repeat" do
      p1 = Post.create(:title => "Foo bar")
      p2 = Post.create(:title => "Bar foo")
      p3 = Post.create(:title => "Hello world.")
      expect(p2.id - 1).to eq p1.id
      expect(p3.id - 2).to eq p1.id
      p3.destroy
      p4 = Post.create(:title => "Create Hellow world again.")
      expect(p4.id - 2).to eq p2.id
    end

    it "does return id when Model.new" do
      expect(Post.new.id).to be_a Integer
      expect(Post.new._id).to be_a Integer
    end

    it "does can find data by String and Integer id" do
      post = Post.create(:title => "Foo bar")
      expect(Post.find(post.id.to_i)).to eq post
      expect(Post.find(post.id.to_s)).to eq post
    end

    it "does can find by where :_id" do
      post1 = Post.create(:title => "Foo bar")
      post2 = Post.create(:title => "Bar Foo")
      post3 = Post.create(:title => "Foo Foo")
      expect(Post.where(:_id => post1.id).first.title).to eq "Foo bar"
      expect(Post.where(:_id => post2.id).first.title).to eq "Bar Foo"
    end

    it "does 1..N working fine" do
      user1 = User.new(:email => "huacnlee@gmail.com",:name => "Jason Lee")
      user1.save
      post1 = Post.create(:title => "Foo bar", :user_id => user1.id)
      expect(post1.user.email).to eq user1.email
      expect(User.first.posts.first.id).to eq post1.id
      expect {
        user1.posts << Post.create(:title => "Bar foo")
      }.to change(User.first.posts, :count).by(1)
    end

    it "does 1..1 working fine." do
      post = Post.create(:title => "Foo bar")
      post_ext = post.build_post_ext(:body_ext => "Bar foo")
      post_ext.save
      expect(Post.first.post_ext.body_ext).to eq "Bar foo"
      expect(post_ext.post).to eq post
      expect(post_ext.post_id).to eq post.id
    end

    it "does N..N working find." do
      post = Post.create(:title => "Foo bar")
      post.tags.create(:name => "Ruby")
      post.tags.create(:name => "Rails")
      post.tags.create(:name => "Python")
      expect(Post.first.tags.count).to eq 3
      post.tags << Tag.create(:name => "Django")
      expect(Post.first.tags.count).to eq 4
      expect(Tag.first.posts.first.id).to eq post.id
      expect(Tag.first.id).to be_a(Integer)
    end

    it "does embedded_in/embeds_many working fine." do
      post = Post.create(:title => "Foo bar")
      post.comments.create(:author => "Monster", :body => "This is comment.")
      post.comments.create(:author => "Do do", :body => "Thanks.")
      expect(Post.first.comments.count).to eq 2
      expect(Post.first.comments.first.id).to be_a(Integer)
    end

    it "does descendant class can working" do
      userlog = UserLog.create(:title => "test user log")
      expect(userlog.errors.count).to eq 0
      taglog = TagLog.create(:title => "test tag log")
      expect(taglog.errors.count).to eq 0
      expect(userlog._type).to eq "UserLog"
      expect(taglog._type).to eq "TagLog"
      expect(UserLog.count).to eq 1
      expect(TagLog.count).to eq 1
      expect(Log.count).to eq 2
      expect(Log.where(:title => "test user log").count).to eq 1
      expect(Log.where(:title => "test user log").first._type).to eq "UserLog"
      expect(Log.where(:title => "test tag log").count).to eq 1
      expect(Log.where(:title => "test tag log").first._type).to eq "TagLog"
    end

    context "when accepts_nested_attributes_for" do
      before { User.accepts_nested_attributes_for :posts }

      it "set association" do
        user = User.new(:email => "t@1.com", :posts_attributes => { "0" => {:title => "This is title!"}})
        user.save
        user.reload
        expect(user.posts.size).to eq(1)
      end
    end
  end
  
  
  describe 'seq cache' do
    let(:cache_key) { "maii-seqs-seq_cache_tests" }
    
    it 'should work' do
      Mongoid::AutoIncrementId.seq_cache_size = 2
      expect(SeqCacheTest.create(name: "Foo bar").id).to eq 1
      expect(Mongoid::AutoIncrementId.cache_store.read(cache_key)).to eq [2]
      expect(SeqCacheTest.create(name: "Foo bar").id).to eq 2
      expect(Mongoid::AutoIncrementId.cache_store.read(cache_key)).to eq []
      Mongoid::AutoIncrementId.seq_cache_size = 5
      expect(SeqCacheTest.create(name: "Foo bar").id).to eq 3
      expect(Mongoid::AutoIncrementId.cache_store.read(cache_key)).to eq [4,5,6,7]
      expect(SeqCacheTest.create(name: "Foo bar").id).to eq 4
      expect(Mongoid::AutoIncrementId.cache_store.read(cache_key)).to eq [5,6,7]
      Mongoid::AutoIncrementId.seq_cache_size = 1
    end
    
  end
end
