require "spec_helper"
include Nanoc::Toolbox::Helpers::GoogleAnalytics

describe Nanoc::Toolbox::Helpers::GoogleAnalytics do
  subject { Nanoc::Toolbox::Helpers::GoogleAnalytics }
  it { should respond_to(:ga_tracking_snippet) }
  describe ".ga_tracking_snippet" do
    it "returns a string that contains the JS" do
      ga_tracking_snippet("").should include("<script")
      ga_tracking_snippet("").should include("var _gaq = _gaq || [];")
    end
    
    it "includes the passed code" do
      ga_tracking_snippet("qwertzuiop").should include("qwertzuiop")      
    end
  end
end