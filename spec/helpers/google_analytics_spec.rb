require "spec_helper"


class GoogleAnalyticsDummyClass
  include Nanoc::Toolbox::Helpers::GoogleAnalytics
  def initialize
    @config = { :ga_tracking_code => "UA-0000000-0" } 
  end
end

describe Nanoc::Toolbox::Helpers::GoogleAnalytics do
  subject { GoogleAnalyticsDummyClass.new }
  
  it { should respond_to(:ga_tracking_snippet) }
  
  describe ".ga_tracking_snippet" do
    
    it "returns a string that contains the JS" do
      subject.ga_tracking_snippet().should include("<script")
      subject.ga_tracking_snippet().should include("var _gaq = _gaq || [];")
    end

    it "includes the passed code" do
      subject.ga_tracking_snippet("UA-123456-1").should include("UA-123456-1")
    end

    it "includes the tracking code from the site config" do
      subject.instance_variable_set(:@config, { :ga_tracking_code => "UA-0000000-0"})
      subject.ga_tracking_snippet().should include "UA-0000000-0"
    end

    it "includes the placeholder code when no value is found" do
      subject.instance_variable_set(:@config, { })
      subject.ga_tracking_snippet().should include "UA-xxxxxx-x"
    end
  end
end
