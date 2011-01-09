require "spec_helper"
include Nanoc::Toolbox::Helpers::Navigation

describe Nanoc::Toolbox::Helpers::Navigation do

  describe ".navigation_for" do
    context "with an existing item" do
      
      context "which has decendents" do
        it "should render " do
          item = double('item')
          item.stub(:children).and_return(nil)
          @items = double('items')
          @items.stub(:find).and_return(item)

          pending
          
        end
      end
      
      context "which hasn't decendents" do
        it "should return nil" do
          item = double('item')
          item.stub(:children).and_return(nil)
          @items = double('items')
          @items.stub(:find).and_return(item)
          
          navigation_for('/').should be_nil
        end
      end
    end
  end
end