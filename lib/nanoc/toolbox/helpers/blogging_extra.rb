require 'nanoc/toolbox/helpers/html_tag'

module Nanoc::Toolbox::Helpers
  # NANOC Helper for giving items extra blog post behavior.
  #
  # This module contains functions for ...
  #
  module BloggingExtra
    include Nanoc::Toolbox::Helpers::HtmlTag

    def add_post_attributes
      @site.config[:post_dirs] ||= ['_posts', '_articles']
      items.each do |item|
        # check the item's parent directory against the post_dirs
        if (item[:filename] && @config[:post_dirs].include?(File.dirname(item[:filename]).split('/').last))
          act_as_post(item)
        end
      end
    end
    
    
    # Enable blog post behavior on an item
    def act_as_post(item)
      fname = slug_for(item)

      # get the date from the filename
      item[:year], item[:month], item[:day] = fname.split("-", 4)[0..2]

      # Strip the date from the filename
      item[:slug] = fname.sub(/^\d+-\d+-\d+-/,'')

      # Set creation date param from the values in the filename
      item[:created_at] = Time.local(item[:year], item[:month], item[:day])

      # Add additional meta data
      item[:kind] = 'article'
      
      # Enable comments unless specifically turned off
      item[:comments] = true unless item[:comments] === false
    end
    
    
    # Get an item's slug if it has one,
    # or use its filename sans extension
    def slug_for(item)
      return item[:slug] if item[:slug]
      
      item[:slug] = File.basename(item[:filename], File.extname(item[:filename]))
      item[:slug].gsub!(/\s+/, '-')
      item[:slug]
    end
    
    
    # Returns a string of links to tag pages,
    # optionally omits the given section
    def tag_links_for(item, omit_tags=[])
      tags = []
      item[:tags].each do |tag|
        unless omit_tags.include? tag
          tags << content_tag('a', tag, {:href => '/' + tag.downcase})
        end
      end
      return tags.join(', ')
    end
  end
end
