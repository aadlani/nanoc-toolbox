require "spec_helper"
include Nanoc::Toolbox::Helpers::BloggingExtra

describe Nanoc::Toolbox::Helpers::BloggingExtra do
  subject { Nanoc::Toolbox::Helpers::BloggingExtra }
  it { should respond_to(:add_post_attributes) }
  it { should respond_to(:act_as_post) }
  it { should respond_to(:slug_for) }
  it { should respond_to(:tag_links_for) }
  
  describe ".slug_for" do
    it "returns the slug set in the item if it's existing" do
      item = { :slug => "abc-def-geh.html" }
      slug_for(item).should == "abc-def-geh.html"
    end
    
    it "generate the slug based on the item filename, by striping spaces" do
      item = { :filename => "abc def geh.html" }
      slug_for(item).should == "abc-def-geh"
    end
  end
  
  describe ".tag_links_for" do
    it "generates the tags lings corresponding to the parameter" do
      tags = %W[a b c d e f]
      item = { :tags => tags }
      tag_links_for(item).split(',').size.should == tags.size
      tags.each do |t|
        tag_links_for(item).should include("<a href=\"/#{t}\"")
      end
    end

    it "generates the same number of links than tags" do
      item = { :tags => %W[a b c d e f] }
      tag_links_for(item).split(',').size.should == 6
    end
    
    it "excludes the tags passed as second parameter" do
      omited = %W[ d e ]
      item = { :tags => %W[a b c d e f] }
      
      generated_links = tag_links_for(item, omited)
      generated_links.split(',').size.should == (item[:tags].size - omited.size)

      omited.each do |t|
        generated_links.should_not include("<a href=\"/#{t}\"")
      end
    end
  end
  
  describe ".act_as_post" do
    it "forces the item kind to article" do
      item = { :filename => "2011-02-12-test-of-post", :extension => ".md"}
      act_as_post(item)
      item[:kind].should == 'article'
    end

    it "handles the date from the filename" do
      item = { :filename => "2011-02-12-test-of-post", :extension => ".md"}
      act_as_post(item)
      item[:created_at].should == Time.local(2011, 02, 12)
      item[:year].should == "2011"
      item[:month].should == "02"
      item[:day].should == "12"
    end
   
    it "do something when no date set in the filename" 

    it "generates a slug from the filename" do
      item = { :filename => "2011-02-12-test-of-post.html", :extension => ".md"}
      act_as_post(item)
      item[:slug].should == "test-of-post.html"
    end

    it "enables by default the comments" do
      item = { :filename => "2011-02-12-test-of-post", :extension => ".md"}
      act_as_post(item)
      item[:comments].should be_true
    end
  end
  
end
