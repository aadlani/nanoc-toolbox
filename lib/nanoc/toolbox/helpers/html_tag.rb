module Nanoc::Toolbox::Helpers

  # NANOC Helper for HTML Tags
  #
  # This module contains functions for generating simple tags with attribute
  #
  # @author Anouar ADLANI <anouar@adlani.com>
  module HtmlTag
    # Simple tag
    #
    # @example
    #   tag("br")
    #    # => <br />
    #
    #   tag("hr", class => "thin", true)
    #    # => <br class="thin">
    #
    #   tag("input", :type => 'text')
    #    # => <input type="text" />
    #
    def tag(name, options={}, open=false)
      "<#{name}#{tag_options(options) if options}#{open ? ">" : " />"}"
    end

    # Content tag
    #
    # @example
    #   content_tag(:p, "Hello world!")
    #    # => <p>Hello world!</p>
    #   content_tag(:div, content_tag(:p, "Hello world!"), :class => "strong")
    #    # => <div class="strong"><p>Hello world!</p></div>
    def content_tag(name, content, options={})
      "<#{name}#{tag_options(options) if options}>#{content}</#{name}>"
    end
    
    protected
      def tag_options(options)
        unless options.empty?
          attributes = []
          options.each do |key, value|
            attributes << %(#{key}="#{value}")
          end
          ' ' + attributes.join(' ')
        end
      end
  end
end