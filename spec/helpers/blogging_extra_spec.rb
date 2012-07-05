require "spec_helper"

class BloggingExtraDummyClass
  include Nanoc::Toolbox::Helpers::BloggingExtra
end

describe Nanoc::Toolbox::Helpers::BloggingExtra do
  

  subject { BloggingExtraDummyClass.new }

  it { should respond_to(:add_post_attributes) }
  it { should respond_to(:act_as_post) }
  it { should respond_to(:slug_for) }
  it { should respond_to(:tag_links_for) }
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
  
  describe ".tag_links_for" do
    it "generates the tags lings corresponding to the parameter" do
      tags = %W[a b c d e f]
      item = { :tags => tags }
      subject.tag_links_for(item).size.should == tags.size
      tags.each do |t|
        subject.tag_links_for(item).should include("<a href=\"/tags/#{t}.html\">#{t}</a>")
      end
    end

    it "generates the same number of links than tags" do
      item = { :tags => %W[a b c d e f] }
      subject.tag_links_for(item).size.should == 6
    end
    
    it "excludes the tags passed as second parameter" do
      omited = %W[ d e ]
      item = { :tags => %W[a b c d e f] }
      
      generated_links = subject.tag_links_for(item, omited)
      generated_links.size.should == (item[:tags].size - omited.size)

      omited.each do |t|
        generated_links.should_not include("<a href=\"/#{t}\"")
      end
    end

    it "handle the URL format passed in param" do
      omited = []
      item = { :tags => %W[a b c d e f] }
      options = {:title => "", :url_tag_pattern => "", :url_format => ""}
      pending "TODO"  
    end

    it "handle the TAG format passed in param"
    it "handle the TITLE format passed in param"
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
      subject.posts_by_date.keys.should eq @last_articles.map {|i| i[:year]}.uniq
      subject.posts_by_date[2010].should eq @last_articles[2..4]
    end
  end
end
