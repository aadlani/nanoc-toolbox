require "spec_helper"
include Nanoc::Toolbox::Helpers::HtmlTag

describe Nanoc::Toolbox::Helpers::HtmlTag do
  describe "#tag" do
    it "returns an simple self-closing tag by default" do
      tag("br").should == "<br />"
    end
    
    it "returns an simple self-closing tag with option" do
      tag("hr", :class => "thin").should == %[<hr class="thin" />]
    end
  end
  
  describe "#content_tag" do
    it "returns an simple with content tag by default" do
      content_tag("b", "Hello").should == "<b>Hello</b>"
    end
    
    it "returns an simple with content tag with options" do
      content_tag("b", "Hello", :class => "highlight").should == %[<b class="highlight">Hello</b>]
    end
  end
end