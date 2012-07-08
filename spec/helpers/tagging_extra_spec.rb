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
      subject.has_tag?(item, 'a').should be_true
    end
    it "returns false when the item contains the desired tag" do
      item = { :tags => ['a', 'b', 'c'] }   
      subject.has_tag?(item, 'd').should be_false
    end
    it "returns fals when the item do not have tag" do
      item = { }   
      subject.has_tag?(item, 'd').should be_false
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
        pending  
     end
  end

  describe ".create_tag_pages" do
     it "Creates in-memory tag pages" do
        pending  
     end
  end
end
