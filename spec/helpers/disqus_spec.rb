require 'spec_helper'

class DummyDisqusClass 
  include Nanoc::Toolbox::Helpers::Disqus
end

describe Nanoc::Toolbox::Helpers::Disqus do
  subject { DummyDisqusClass.new }

  it { should respond_to :disqus_id_for }
  it { should respond_to :disqus_js_snippet }
  it { should respond_to :disqus_nojs_snippet }

  describe ".disqus_id_for" do
    it "calls slug_for to generate the id" do
      subject.should_receive(:slug_for).once.and_return('hello-world')
      subject.disqus_id_for({}).should eq 'hello_world'
    end

    it "prepends the disqus prefix id if passed in the options" do
      subject.should_receive(:slug_for).once.and_return('hello-world')
      subject.disqus_id_for({}, {:disqus_id_prefix => 'my_website_'}).should eq 'my_website_hello_world'
    end
  end

  describe ".disqus_js_snippet" do
    it "returns the JS snippet" do
      subject.disqus_js_snippet.should =~/<script type="text\/javascript">/
    end

    it "declares prefixed variables passed in options" do
      menu = subject.disqus_js_snippet({:name => "Anouar", :lastname => 'ADLANI'})
      menu.should =~/var disqus_name = 'Anouar';/
      menu.should =~/var disqus_lastname = 'ADLANI';/
    end
  end

  describe ".disqus_nojs_snippet" do
    it "returns the default noscript snippet" do
      subject.disqus_nojs_snippet.should eq "<noscript>Please enable JavaScript to view the <a href=\"http://disqus.com/?ref_noscript\">comments powered by Disqus.</a></noscript>"
    end

    it "render the specified message" do
      subject.disqus_nojs_snippet("No message").should eq "<noscript>No message</noscript>"
    end
  end
end
