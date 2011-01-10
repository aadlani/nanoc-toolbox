module Nanoc::Toolbox::Helpers

  # NANOC Helper for the Gravatar avatars
  #
  # This module contains functions for generating URL or IMG tags to
  # display the Gravatar linked to an address email, or the default gravatar
  #
  # @see http://en.gravatar.com/
  #
  # @author Anouar ADLANI <anouar@adlani.com>
  module HtmlTag
    
    def tag(name, options={}, open=false)
      "<#{name}#{tag_options(options) if options}#{open ? ">" : " />"}"
    end
    
    def content_tag(name, content="", options={})
      "<#{name}#{tag_options(options) if options}>#{content}</#{name}>"
    end
    
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