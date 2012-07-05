require "spec_helper"
include Nanoc::Toolbox::Helpers::GoogleAnalytics

describe Nanoc::Toolbox::Helpers::GoogleAnalytics do
  subject { Nanoc::Toolbox::Helpers::GoogleAnalytics }
  it { should respond_to(:ga_tracking_snippet) }
  describe ".ga_tracking_snippet" do
    before do
     @config = {}
    end
    it "returns a string that contains the JS" do
      ga_tracking_snippet().should include("<script")
      ga_tracking_snippet().should include("var _gaq = _gaq || [];")
    end

    it "includes the passed code" do
      ga_tracking_snippet("UA-123456-1").should include("UA-123456-1")
    end

    it "includes the tracking code from the site config" do
      @config = { :ga_tracking_code => "UA-0000000-0"}
      ga_tracking_snippet().should include @config[:ga_tracking_code]
    end

    it "includes the placeholder code when no value is found" do
      ga_tracking_snippet().should include "UA-xxxxxx-x"
    end
  end
end
