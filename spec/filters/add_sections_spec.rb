require "spec_helper"

describe Nanoc::Toolbox::Filters::AddSections do
  before(:each) do
    @filter = described_class.new
  end
  
  describe ".run" do
    it "minifies javascript" do
      content = "<h1>A Title<h1/><h2>A Second Title<h2/>"
      result = @filter.run(content)
      result.should_not eq content
      result.should =~ /"section"/
    end
  end
end
