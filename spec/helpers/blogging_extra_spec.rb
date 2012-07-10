require "spec_helper"

class BloggingExtraDummyClass
  include Nanoc::Toolbox::Helpers::BloggingExtra
  def initialize
    @config = {}
  end
end

describe Nanoc::Toolbox::Helpers::BloggingExtra do

  subject { BloggingExtraDummyClass.new }

  it { should respond_to(:add_post_attributes) }
  it { should respond_to(:act_as_post) }
  it { should respond_to(:slug_for) }
  it { should respond_to(:recent_posts) }
  it { should respond_to(:posts_by_date) }

  describe ".slug_for" do
    it "returns the slug set in the item if it's existing" do
      item = { :slug => "abc-def-geh.html" }
      subject.slug_for(item).should == "abc-def-geh.html"
    end

    it "generate the slug based on the item filename, by striping spaces" do
      item = { :filename => "abc def geh.html" }
      subject.slug_for(item).should == "abc-def-geh"
    end
  end

  describe ".add_post_attributes" do
    it "defines the items as posts when located in the defined folders" do
      articles = [
        Nanoc3::Item.new("", { :extension => ".md", :created_at => "01/12/2012 22:14" }, "test-of-post2"),
        Nanoc3::Item.new("", { :filename => "_posts/test-of-post2", :extension => ".md", :created_at => "01/12/2012 22:14" }, "test-of-post2"),
        Nanoc3::Item.new("", { :filename => "_articles/test-of-post3", :extension => ".md", :created_at => "01/12/2010 22:13" }, "test-of-post3"),
        Nanoc3::Item.new("", { :filename => "test-of-post6", :extension => ".md", :created_at => "01/12/2008 22:10" }, "test-of-post6")]

      subject.stub(:items).and_return(articles)
      subject.should_receive(:act_as_post).with(an_instance_of(Nanoc3::Item)).twice
      subject.add_post_attributes
    end
  end

  describe ".act_as_post" do
    before do
      @item = { :filename => "2011-02-12-test-of-post", :extension => ".md", :created_at => "01/12/2011 22:15" }
      subject.act_as_post(@item)
    end

    it "forces the item kind to article" do
      @item[:kind].should == 'article'
    end

    it "handles the date from the filename" do
      @item[:created_at].should == Time.local(2011, 02, 12)
      @item[:year].should  == "2011"
      @item[:month].should == "02"
      @item[:day].should   == "12"
    end

    it "do something when no date set in the filename" do
      @item[:year].to_i.should  == @item[:created_at].year
      @item[:month].to_i.should == @item[:created_at].month
      @item[:day].to_i.should   == @item[:created_at].day
    end

    it "generates a slug from the filename" do
      @item[:slug].should == "test-of-post"
    end

    it "enables by default the comments" do
      @item[:comments].should be_true
    end
  end

  describe ".recent_posts" do
    before do
      @last_articles = [
        Nanoc3::Item.new("", { :filename => "test-of-post1", :extension => ".md", :created_at => "01/12/2008 22:15" }, "test-of-post1"),
        Nanoc3::Item.new("", { :filename => "test-of-post2", :extension => ".md", :created_at => "01/12/2012 22:14" }, "test-of-post2"),
        Nanoc3::Item.new("", { :filename => "test-of-post3", :extension => ".md", :created_at => "01/12/2010 22:13" }, "test-of-post3"),
        Nanoc3::Item.new("", { :filename => "test-of-post4", :extension => ".md", :created_at => "01/12/2010 22:12" }, "test-of-post4"),
        Nanoc3::Item.new("", { :filename => "test-of-post5", :extension => ".md", :created_at => "01/11/2010 22:11" }, "test-of-post5"),
        Nanoc3::Item.new("", { :filename => "test-of-post6", :extension => ".md", :created_at => "01/12/2013 22:10" }, "test-of-post6")]

      subject.stub(:sorted_articles).and_return(@last_articles)
    end

    it "returns the requested recent posts" do
      posts = subject.recent_posts(3)
      posts.length.should eq 3
      posts.should_not include(@last_articles.last)
      posts.should     include(@last_articles.first)
    end

    it "returns the existing posts when requesting more than" do
      posts = subject.recent_posts(13)
      posts.length.should eq @last_articles.length
      posts.should eq(@last_articles)
    end

    it "excludes the current item when requested" do
      posts = subject.recent_posts(6, @last_articles.last)
      posts.should_not include(@last_articles.last)
    end
  end

  describe ".posts_by_date" do
    before do
      @last_articles = []
      articles = [
        Nanoc3::Item.new("", { :filename => "test-of-post1", :extension => ".md", :created_at => "01/12/2013 22:15" }, "test-of-post1"),
        Nanoc3::Item.new("", { :filename => "test-of-post2", :extension => ".md", :created_at => "01/12/2012 22:14" }, "test-of-post2"),
        Nanoc3::Item.new("", { :filename => "test-of-post3", :extension => ".md", :created_at => "01/12/2010 22:13" }, "test-of-post3"),
        Nanoc3::Item.new("", { :filename => "test-of-post4", :extension => ".md", :created_at => "01/12/2010 22:12" }, "test-of-post4"),
        Nanoc3::Item.new("", { :filename => "test-of-post5", :extension => ".md", :created_at => "01/02/2010 22:11" }, "test-of-post5"),
        Nanoc3::Item.new("", { :filename => "test-of-post6", :extension => ".md", :created_at => "01/12/2008 22:10" }, "test-of-post6")]

      articles.each  do |article|
        @last_articles << subject.act_as_post(article)
      end
      subject.stub(:sorted_articles).and_return(@last_articles)
    end

    it "returns the article grouped by years and months" do
      grouped_article =  subject.posts_by_date
      grouped_article.keys.should eq @last_articles.map {|i| i[:year]}.uniq
      grouped_article[2010][12].should eq @last_articles[2..3]
    end
  end
end

