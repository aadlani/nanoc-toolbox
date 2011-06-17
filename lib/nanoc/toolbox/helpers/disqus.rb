require 'nanoc/toolbox/helpers/blogging_extra'

module Nanoc::Toolbox::Helpers

  # NANOC Helper for Disqus comments
  #
  # This module contains functions for ...
  #
  # @see http://disqus.com/
  module Disqus
    include Nanoc::Toolbox::Helpers::BloggingExtra
    
    # Creates an id out of the page slug
    # that disqus uses for an id
    # TODO: nothing currently makes sure they're unique
    def disqus_id_for(item, options={})
      id = ''
      id += options[:disqus_id_prefix] if options[:disqus_id_prefix]
      id += slug_for(item)
      id.gsub(/-/, '_')
    end
  end
end
