require "spec_helper"


class NavigationDummyClass
end

describe Nanoc::Toolbox::Helpers::Navigation do
  before(:each) do
    @navigation = NavigationDummyClass.new
    @navigation.extend(described_class)
  end

  describe ".render_menu" do
    context "when no options specified" do
      it "returns nil when the menu is empty" do
        @navigation.render_menu([]).should be_nil
      end

      it "returns a simple ordered list when given a 1 level menu" do
        sections = [{:title => "Title", :link => "http://example.com" }]
        html_menu = %[<ol><li><a href="http://example.com">Title</a></li></ol>]

        @navigation.render_menu(sections).should == html_menu
      end

      it "returns a nested ordered list when given a multi level menu" do
        sections     = [{:title => "Title", :link => "http://example.com", :subsections => [{:title => "Title", :link => "http://example.com" },{:title => "Title", :link => "http://example.com" }] }]
        html_menu = %[<ol><li><a href="http://example.com">Title</a><ol><li><a href="http://example.com">Title</a></li><li><a href="http://example.com">Title</a></li></ol></li></ol>]

        @navigation.render_menu(sections).should == html_menu
      end

      it "returns only 3 levels when nothing is specified in the options" do
        sections     = [
          {:title => "Title", :link => "http://example.com", :subsections => [
            {:title => "Title", :link => "http://example.com", :subsections => [
              {:title => "Title", :link => "http://example.com", :subsections => [
                {:title => "Title", :link => "http://example.com"}
              ]}
            ]}
          ]}]
        html_menu = %[<ol><li><a href="http://example.com">Title</a><ol><li><a href="http://example.com">Title</a><ol><li><a href="http://example.com">Title</a></li></ol></li></ol></li></ol>]
        @navigation.render_menu(sections).should == html_menu
      end

      it "returns menu within an html ordered list (<ol> <li>) when nothing is specified in the options" do
        sections = [{:title => "Title", :link => "http://example.com" }]
          @navigation.render_menu(sections).should =~ /^<ol><li>/
      end
    end
    
    context "when no options specified" do
      it "returns menu within a html unordered list (<ul> <li>) when it is specified in the options" do
        sections = [{:title => "Title", :link => "http://example.com" }]
          @navigation.render_menu(sections, :collection_tag => 'ul').should =~ /^<ul><li>/
      end
      
      it "returns menu within a div/span when it is specified in the options" do
        sections = [{:title => "Title", :link => "http://example.com" }]
          @navigation.render_menu(sections, :collection_tag => 'div', :item_tag => 'span').should =~ /^<div><span>/
      end
      
      it "returns only 2 levels when it's specified in the options" do
        sections     = [
          {:title => "Title", :link => "http://example.com", :subsections => [
            {:title => "Title", :link => "http://example.com", :subsections => [
              {:title => "Title", :link => "http://example.com", :subsections => [
                {:title => "Title", :link => "http://example.com"}
              ]}
            ]}
          ]}]
        html_menu = %[<ol><li><a href="http://example.com">Title</a><ol><li><a href="http://example.com">Title</a></li></ol></li></ol>]
        @navigation.render_menu(sections, :depth => 2).should == html_menu
      end
    end
  end

  describe ".toc_for" do
    it "should return a toc for a page"
  end
end
