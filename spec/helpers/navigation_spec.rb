require "spec_helper"

class NavigationDummyClass
  include Nanoc::Toolbox::Helpers::Navigation
end

describe Nanoc::Toolbox::Helpers::Navigation do
  subject { NavigationDummyClass.new }

  it { should respond_to(:render_menu) }
  it { should respond_to(:navigation_for) }
  it { should respond_to(:toc_for) }
  it { should respond_to(:breadcrumb_for) }

  describe ".render_menu" do
    context "when no options specified" do
      it "returns nil when the menu is empty" do
        subject.render_menu([]).should be_nil
      end

      it "returns a simple ordered list when given a 1 level menu" do
        sections = [{:title => "Title", :link => "http://example.com" }]
        html_menu = %[<ol><li><a href="http://example.com">Title</a></li></ol>]

        subject.render_menu(sections).should == html_menu
      end

      it "returns a nested ordered list when given a multi level menu" do
        sections     = [{:title => "Title", :link => "http://example.com", :subsections => [{:title => "Title", :link => "http://example.com" },{:title => "Title", :link => "http://example.com" }] }]
        html_menu = %[<ol><li><a href="http://example.com">Title</a><ol><li><a href="http://example.com">Title</a></li><li><a href="http://example.com">Title</a></li></ol></li></ol>]

        subject.render_menu(sections).should == html_menu
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
        subject.render_menu(sections).should == html_menu
      end

      it "returns menu within an html ordered list (<ol> <li>) when nothing is specified in the options" do
        sections = [{:title => "Title", :link => "http://example.com" }]
          subject.render_menu(sections).should =~ /^<ol><li>/
      end
    end

    context "when no options specified" do
      it "returns menu within a html unordered list (<ul> <li>) when it is specified in the options" do
        sections = [{:title => "Title", :link => "http://example.com" }]
          subject.render_menu(sections, :collection_tag => 'ul').should =~ /^<ul><li>/
      end

      it "returns menu within a div/span when it is specified in the options" do
        sections = [{:title => "Title", :link => "http://example.com" }]
          subject.render_menu(sections, :collection_tag => 'div', :item_tag => 'span').should =~ /^<div><span>/
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
        subject.render_menu(sections, :depth => 2).should == html_menu
      end
    end
  end

  describe ".toc_for" do
    before :all do
      @content = <<-EOS
        <html>
          <body>
            <div id="title1" class="section">
              <h1>Title 1</h1>
              <div  id="title21" class="section">
                <h2>Title 2<h2>
              </div>
              <div id="title22" class="section">
                <h2>Title 2<h2>
              </div>
              <div  id="title23" class="section">
                <h2>Title 2<h2>
              </div>
            </div>
          </body>
        </html>
      EOS
    end

    it "should return a toc for a page" do
      item_rep = Nanoc::ItemRep.new(Nanoc::Item.new("", {:title => ""},  "/yetAnotherItem/"), "")
      item_rep.instance_variable_set :@content, {:pre => @content}

      subject.toc_for(item_rep).should include "#title1"
      subject.toc_for(item_rep).should include "#title21"
      subject.toc_for(item_rep).should include "#title22"
      subject.toc_for(item_rep).should include "#title23"

      subject.toc_for(item_rep).should include "Title 1"
      subject.toc_for(item_rep).should include "Title 2"
    end

    it "calls find_to_sections and render_menu for the formating" do
      item_rep = Nanoc::ItemRep.new(Nanoc::Item.new("", {:title => ""},  "/yetAnotherItem/"), "")
      item_rep.instance_variable_set :@content, {:pre => @content}

      subject.should_receive(:find_toc_sections).once
      subject.should_receive(:render_menu).once
      subject.toc_for(item_rep)
    end

    it "returns an empty string when the main content is empty" do
      item_rep = Nanoc::ItemRep.new(Nanoc::Item.new("", {:title => ""},  "/yetAnotherItem/"), "")
      item_rep.instance_variable_set :@content, {:pre => ""}
      subject.toc_for(item_rep).should eq ""
    end

    it "returns an empty string when the main content is empty" do
      item_rep = Nanoc::ItemRep.new(Nanoc::Item.new("", {:title => ""},  "/yetAnotherItem/"), "")
      item_rep.instance_variable_set :@content, {:pre => @content}
      subject.toc_for(item_rep, {:path => "section"}).should eq ""
    end
  end

  describe ".navigation_for" do
    it "should return a navigation menu for a item"
  end

  describe ".breadcrumb_for" do
    it "should return a breadcrumb for an item"
  end
end
