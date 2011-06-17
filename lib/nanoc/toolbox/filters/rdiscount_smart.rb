module Nanoc::Toolbox::Filters
  # NANOC Filter for Markdown rendering with SmartyPants
  class RdiscountSmart < Nanoc3::Filter
    
    identifier :rdiscount_smart
    
    # Tidy the HTML output
    # Runs the content through Rdiscount renderer,
    # with SmartyPants option enabled.
    #
    # @param [String] content The content to filter
    # @param [String] params This method takes no options.
    # @return [String] The filtered content
    def run(content, params = {})
      require 'rdiscount'
      ::RDiscount.new(content, :smart).to_html
    end
  end
end