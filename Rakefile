require 'rake'
require "rspec"
require File.expand_path('../spec/spec_helper', __FILE__)

task :default do
  system 'bundle exec rspec spec'
end

task :benchmark do
  Benchmark.bm do|bm|
    Post.delete_all
    bm.report("Generate 1") do
      1.times do 
        Post.create(:title => "Foo bar")
      end
    end
    puts "Post current: #{Post.count}"
    puts ""
    
    bm.report("Generate 100") do
      100.times do 
        Post.create(:title => "Foo bar")
      end
    end
    puts "Post current: #{Post.count}"
    puts ""
    
    bm.report("Generate 10,000") do
      10_000.times do 
        Post.create(:title => "Foo bar")
      end
    end
    puts "Post current: #{Post.count}"
    puts ""
  end
end