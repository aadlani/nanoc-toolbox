require 'spec_helper'

class DummyTaggingExtra
  include Nanoc::Toolbox::Helpers::TaggingExtra
end

describe Nanoc::Toolbox::Helpers::TaggingExtra do
  subject { DummyTaggingExtra.new }

  it { should respond_to :tag_set }
  it { should respond_to :has_tag? }
  it { should respond_to :items_with_tag }
  it { should respond_to :count_tags }
  it { should respond_to :rank_tags }
  it { should respond_to :create_tag_pages }
  it { should respond_to :tag_links_for }

  describe ".tag_set" do
    it "returns all the tags present in a collection of item" do
      items = [ {:tags => ['a', 'b', 'c', 'd']}, {:tags => ['e', 'f']} ]
      subject.tag_set(items).should eq %w{a b c d e f}
    end

    it "returns distinct tags in a collection of items" do
      items = [ {:tags => ['a', 'b', 'c', 'd']}, {:tags => ['a', 'd', 'c', 'e', 'f']}]
      subject.tag_set(items).should eq %w{a b c d e f}
    end

    it "returns tags without nil value when an item has no tag" do
      items = [ {:tags => ['a', 'b', 'c', 'd']}, {:tags => ['a', 'd', 'c', 'e', 'f']}, {}]
      subject.tag_set(items).should eq %w{a b c d e f}
    end
  end

  describe ".has_tag?" do
    it "returns true when the item contains the desired tag" do
      item = { :tags => ['a', 'b', 'c'] }
      subject.has_tag?(item, 'a').should be true
    end
    it "returns false when the item contains the desired tag" do
      item = { :tags => ['a', 'b', 'c'] }
      subject.has_tag?(item, 'd').should be false
    end
    it "returns fals when the item do not have tag" do
      item = { }
      subject.has_tag?(item, 'd').should be false
    end
  end

  describe ".items_with_tag" do
    it "returns only the item whith the specified tag" do
      item_a = {:tags => ['a', 'b', 'c', 'd']}
      item_b = {:tags => ['a', 'd', 'c', 'e', 'f']}
      items = [ item_a, item_b, {}]
      subject.items_with_tag('f', items).should eq [item_b]
    end

    it "returns only all the item whith the specified tag" do
      item_a = {:tags => ['a', 'b', 'c', 'd']}
      item_b = {:tags => ['a', 'd', 'c', 'e', 'f']}
      items = [ item_a, item_b, {}]
      subject.items_with_tag('a', items).should eq [item_a, item_b]
    end

    it "returns an empty array when no item has been found" do
      item_a = {:tags => ['a', 'b', 'c', 'd']}
      item_b = {:tags => ['a', 'd', 'c', 'e', 'f']}
      items = [ item_a, item_b, {}]
      subject.items_with_tag('g', items).should eq []
    end
  end

  describe ".count_tag" do
    it "return the occurences of all the tags in a collection of item" do
      items = [ {:tags => ['a', 'b', 'c', 'd']}, {:tags => ['a', 'd', 'c', 'e' ]}]
      subject.count_tags(items).should eq({'a' => 2, 'b' => 1, 'c' => 2, 'd' => 2, 'e' => 1 })
    end
    it "return the occurences of all the tags without the empty item" do
      items = [ {:tags => ['a', 'b', 'c', 'd']}, {:tags => ['a', 'd', 'c', 'e' ]}, {}]
      subject.count_tags(items).should eq({'a' => 2, 'b' => 1, 'c' => 2, 'd' => 2, 'e' => 1 })
    end
  end

  describe ".rank_tags" do
     it "Sort the tags of an item collection in N classes of rank" do
       items = [ {:tags => ['a', 'b']}, {:tags => ['b', 'c']} ]
       subject.rank_tags(2, items)['a'].should eq 1
       subject.rank_tags(2, items)['b'].should eq 0
       subject.rank_tags(2, items)['c'].should eq 1
     end

     it "Raises exception when the number of argument is invalid" do
       items = [ {:tags => ['a', 'b']}, {:tags => ['b', 'c']} ]
       lambda { subject.rank_tags(-1, items) }.should raise_error ArgumentError
       lambda { subject.rank_tags(0, items) }.should raise_error ArgumentError
       lambda { subject.rank_tags(1, items) }.should raise_error ArgumentError
     end
  end

  describe ".create_tag_pages" do
     it "Creates in-memory tag pages" do
       subject.instance_variable_set(:@items, [ {:tags => ['a', 'b']}, {:tags => ['b', 'c']} ])

       expect {
         subject.create_tag_pages
       }.to change { subject.instance_variable_get(:@items).size }.by(3)

       subject.instance_variable_get(:@items).last(3).each do |tag_item|
         tag_item.should be_a Nanoc::Item
         tag_item.identifier.should =~ /^\/tags\//
       end
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
      tags = %W[a b c d e f]
      subject.tag_links_for({ :tags => tags }).size.should == 6
    end

    it "excludes the tags passed as second parameter" do
      omited = %W[ d e ]
      item = { :tags => %W[a b c d e f] }

      generated_links = subject.tag_links_for(item, omited)
      generated_links.size.should == (item[:tags].size - omited.size)

      omited.each do |t|
        generated_links.should_not include("<a href=\"/tags/#{t}.html\">#{t}</a>")
      end
    end

    it "handle the tag format in the URL and title passed in param" do
      tags = %W[a b c d e f]
      item = { :tags => tags }
      omited = []
      options = { :title => "all articles tagged with %%TAGNAME%%", :tag_pattern => "%%TAGNAME%%", :url_format => "/tags/tag_%%TAGNAME%%.html"}

      generated_links = subject.tag_links_for(item, omited, options)
      tags.each do |t|
        generated_links.should include("<a href=\"/tags/tag_#{t}.html\">all articles tagged with #{t}</a>")
      end
    end

  end
end
