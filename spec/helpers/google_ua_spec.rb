require "spec_helper"


class GoogleUADummyClass
  include Nanoc::Toolbox::Helpers::GoogleUA
  def initialize
    @config = { :ga_tracking_code => "UA-0000000-0" } 
  end
end

describe Nanoc::Toolbox::Helpers::GoogleUA do
  subject { GoogleUADummyClass.new }
  
  it { should respond_to(:ua_tracking_snippet) }
  
  describe ".ua_tracking_snippet" do
    
    it "returns a string that contains the JS" do
      subject.ua_tracking_snippet().should include("<script")
      subject.ua_tracking_snippet().should include("ga('create'")
      subject.ua_tracking_snippet().should include("ga('send', 'pageview');")
    end

    it "includes the passed code" do
      subject.ua_tracking_snippet("UA-123456-1").should include("UA-123456-1")
    end

    it "includes the tracking code from the site config" do
      subject.instance_variable_set(:@config, { :ga_tracking_code => "UA-0000000-0"})
      subject.ua_tracking_snippet().should include "UA-0000000-0"
    end

    it "includes the placeholder code when no value is found" do
      subject.instance_variable_set(:@config, { })
      subject.ua_tracking_snippet().should include "UA-xxxxxx-x"
    end
  end
end
