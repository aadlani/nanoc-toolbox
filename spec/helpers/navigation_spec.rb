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
    before do
      @sections     = [
        {:title => "Title", :link => "http://example.com", :subsections => [
          {:title => "Title", :link => "http://example.com", :subsections => [
            {:title => "Title", :link => "http://example.com", :subsections => [
              {:title => "Title", :link => "http://example.com"}
            ]}
          ]}
        ]}]
    end

    context "when no options specified" do

      it "returns nil when the menu is empty" do
        subject.render_menu([]).should be_nil
      end

      it "returns a simple ordered list when given a 1 level menu" do
        sections = [{:title => "Title", :link => "http://example.com" }]
        html_menu = %[<ol class="menu"><li><a href="http://example.com">Title</a></li></ol>]
        subject.render_menu(sections).should == html_menu
      end

      it "returns a nested ordered list when given a multi level menu" do
        html_menu = %[<ol class="menu"><li><a href="http://example.com">Title</a><ol class="menu"><li><a href="http://example.com">Title</a><ol class="menu"><li><a href="http://example.com">Title</a></li></ol></li></ol></li></ol>]
        subject.render_menu(@sections).should == html_menu
      end

      it "returns only 3 levels deep" do
          html_menu = %[<ol class="menu"><li><a href="http://example.com">Title</a><ol class="menu"><li><a href="http://example.com">Title</a><ol class="menu"><li><a href="http://example.com">Title</a></li></ol></li></ol></li></ol>]
          subject.render_menu(@sections).should == html_menu
      end

      it "returns menu within an html ordered list with menu class(<ol> <li>)" do
        subject.render_menu(@sections).should =~ /^<ol class="menu"><li>/
      end
    end

    context "when options specified" do
      it "renders a title" do
        subject.render_menu(@sections, :title => 'title').should =~ /^<h2>title<\/h2>/
        subject.render_menu(@sections, :title => 'title', :title_tag => 'h1').should =~ /^<h1>title<\/h1>/
      end
      it "returns menu within a html unordered list (<ul> <li>) " do
        subject.render_menu(@sections, :collection_tag => 'ul').should =~ /^<ul class="menu"><li>/
      end

      it "returns menu within a div/span " do
        subject.render_menu(@sections, :collection_tag => 'div', :item_tag => 'span').should =~ /^<div class="menu"><span>/
      end

      it "returns only 2 levels deep" do
        html_menu = %[<ol class="menu"><li><a href="http://example.com">Title</a><ol class="menu"><li><a href="http://example.com">Title</a></li></ol></li></ol>]
        subject.render_menu(@sections, :depth => 2).should == html_menu
      end

      it "set a specific class name" do
        subject.render_menu(@sections, :collection_tag => 'ul').should =~ /^<ul class="menu"><li>/
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

      @item_rep = Nanoc::ItemRep.new(Nanoc::Item.new("", {:title => ""},  "/yetAnotherItem/"), "")
      @item_rep.instance_variable_set :@content, {:pre => @content}
    end

    it "should return a toc for a page" do
      subject.toc_for(@item_rep).should include "#title1"
      subject.toc_for(@item_rep).should include "#title21"
      subject.toc_for(@item_rep).should include "#title22"
      subject.toc_for(@item_rep).should include "#title23"

      subject.toc_for(@item_rep).should include "Title 1"
      subject.toc_for(@item_rep).should include "Title 2"
    end

    it "calls find_to_sections and render_menu for the formating" do
      subject.should_receive(:find_toc_sections).once
      subject.should_receive(:render_menu).once
      subject.toc_for(@item_rep)
    end

    it "returns an empty string when the main content is empty" do
      @item_rep.instance_variable_set :@content, {:pre => ""}
      subject.toc_for(@item_rep).should eq ""
    end

    it "returns an empty string when the provided css path returns nothing" do
      subject.toc_for(@item_rep, {:path => "section"}).should eq ""
    end
  end

  describe ".navigation_for" do
    it "should return a navigation menu for a item" 
  end

  describe ".breadcrumb_for" do
    before(:all) do
      @items = {
        "/" => Nanoc::Item.new("", {:title => "Home"},  "/"),
        "/yetAnotherItem/" => Nanoc::Item.new("", {:title => "Sub1"},  "/yetAnotherItem/"),
        "/yetAnotherItem/last/edit/" => Nanoc::Item.new("", {:title => "Sub2"},  "/yetAnotherItem/last/edit/")
      }
      subject.instance_variable_set :@items, @items
    end

    it "should return a breadcrumb for an item" do
      subject.should_receive(:relative_path_to).exactly(2).times { "./" }
      breadcrumb = subject.breadcrumb_for('/yetAnotherItem/')
      breadcrumb.should include "Home"
      breadcrumb.should_not include "Sub2"
    end

    it "should return a breadcrumb even if an empty element" do
      subject.should_receive(:relative_path_to).exactly(3).times { "./" }
      breadcrumb =  subject.breadcrumb_for('/yetAnotherItem/last/edit')
      breadcrumb.should include "Home"
      breadcrumb.should include "Sub1"
      breadcrumb.should include "Sub2"
    end
  end
end
