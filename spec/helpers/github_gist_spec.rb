require "spec_helper"

class GithubGistDummyClass
  include Nanoc::Toolbox::Helpers::GithubGist
end

describe Nanoc::Toolbox::Helpers::GithubGist do
  subject { GithubGistDummyClass.new }
  it {should respond_to(:gist) }

  describe "#gist" do
    context "without a filename" do
      it "takes at list a Gist ID as parameter" do
        lambda{ subject.gist }.should raise_error(ArgumentError)
      end

      it "ensures that Gist ID is an Integer or a hex number" do
        lambda{ subject.gist('123') }.should_not raise_error(ArgumentError)
        lambda{ subject.gist(12345) }.should_not raise_error(ArgumentError)
        lambda{ subject.gist('decafbad123') }.should_not raise_error(ArgumentError)
        lambda{ subject.gist('+supercool+xxx') }.should raise_error(ArgumentError)
      end

      it "returns the script tag for a gist" do
        src = "https://gist.github.com/123.js"
        subject.gist(123).should eq %Q{<script src="#{src}"></script>}
      end
    end

    context "with a filename" do
      it "ensures that the file name is an String" do
        lambda{ subject.gist(12345, 12345) }.should raise_error(ArgumentError)
        lambda{ subject.gist(12345, 'index.html') }.should_not raise_error(ArgumentError)
      end

      it "returns the script tag for a specific file if specified" do
        src = "https://gist.github.com/123.js?file=README.md"
        subject.gist(123, "README.md").should eq %Q{<script src="#{src}"></script>}
      end
    end
  end
end
