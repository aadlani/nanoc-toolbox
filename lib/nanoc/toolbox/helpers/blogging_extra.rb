require 'nanoc/toolbox/helpers/html_tag'


module Nanoc::Toolbox::Helpers
  # NANOC Helper for giving items extra blog post behavior.
  #
  # This module contains functions for ...
  #
  module BloggingExtra
    include Nanoc::Toolbox::Helpers::HtmlTag
    include Nanoc3::Helpers::Blogging

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

      if fname =~ /^\d+-\d+-\d+-/
        # get the date from the filename
        item[:year], item[:month], item[:day] = fname.split("-", 4)[0..2]

        # Set creation date param from the values in the filename
        item[:created_at] = Time.local(item[:year], item[:month], item[:day])
      else
        item[:created_at] ||= Time.now
        item[:created_at] = attribute_to_time(item[:created_at])

        # get the date from 
        item[:year]  = item[:created_at].year
        item[:month] = item[:created_at].month
        item[:day]   = item[:created_at].day
      end

      # Strip the date from the filename
      item[:slug] = fname.sub(/^\d+-\d+-\d+-/,'')


      # Add additional meta data
      item[:kind] = 'article'

      # Enable comments unless specifically turned off
      item[:comments] = true unless item[:comments] === false
      item
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
    def tag_links_for(item, omit_tags=[], options={})
      tags = []
      return tags unless item[:tags]

      options[:title]           ||= ""
      options[:url_tag_pattern] ||= "%%tag%%"
      options[:url_format]      ||= "/tags/#{options[:url_tag_pattern]}.html"

      item[:tags].each do |tag|
        unless omit_tags.include? tag
					url = options[:url_format].gsub(options[:url_tag_pattern], tag.downcase)
          tags << content_tag('a', tag, {:href => url})
        end
      end
      return tags
    end
    
    
    # Returns n number of recent posts
    def recent_posts(count=5, current_item=nil)
      recents = sorted_articles
      recents -= [current_item] if recents.include?(current_item)
      return recents[0, count]
    end
    
    
    #=> { 2011 => { 12 => [item0, item1], 3 => [item0, item2]}, 2010 => {12 => [...]}}
    def posts_by_date
      per_year = sorted_articles.group_by{|i| i[:year]}
      per_year.merge({}) { |key, old, new| old.group_by{|i| i[:month]}}
    end
  end
end
