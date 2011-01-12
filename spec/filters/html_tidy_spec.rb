require "spec_helper"

describe Nanoc::Toolbox::Filters::HtmlTidy do
  before(:each) do
    @filter = described_class.new
    @invalid_output = "<h1>"
    @valid_output = <<-EOS
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd">
<html><body><h1></h1></body></html>
EOS
    
  end
  describe ".run" do
    it "tidy non-coherent html to a well-formed document" do
      @filter.run(@invalid_output).should == @valid_output
    end
    
    it "calls Nokogiri to parse the content" do
      Nokogiri::HTML::Document.should_receive(:parse).with(@invalid_output).and_return(Nokogiri::HTML::Document.new)
      @filter.run(@invalid_output)
    end
    
  end
end