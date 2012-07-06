require "spec_helper"

describe Nanoc::Toolbox::Filters::JsMinify do
  before(:each) do
    @filter = described_class.new
  end
  
  describe ".run" do
    it "minifies javascript" do
      content = "alert('Hello World!'); /*Print Hello world*/\n"
      @filter.run(content).should_not eq content
    end
  end
end


