module Nanoc::Toolbox::Filters
  # NANOC Filter for html output tidy
  #
  # @author Anouar ADLANI <anouar@adlani.com>
  class HtmlTidy < Nanoc3::Filter
    
    identifier :html_tidy
    
    # Tidy the HTML output
    # Runs the content through Nokogiry document parser, and request the html output, 
    # which is tidied by default.
    #
    # @param [String] content The content to filter
    # @param [String] params This method takes no options.
    # @return [String] The filtered content
    def run(content, params = {})
      require 'nokogiri'
      Nokogiri::HTML::Document.parse(content).to_html
    end
  end
end