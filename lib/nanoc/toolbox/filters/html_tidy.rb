module Nanoc::Toolbox::Filters
  class HtmlTidy < Nanoc3::Filter
    identifier :html_tidy
    
    def run(content, params = {})
      require 'nokogiri'
      Nokogiri::HTML::Document.parse(content).to_html
    end
  end
end