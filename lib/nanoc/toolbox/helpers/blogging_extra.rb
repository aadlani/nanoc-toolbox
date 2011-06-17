require 'nanoc/toolbox/helpers/html_tag'

module Nanoc::Toolbox::Helpers
  # NANOC Helper for giving items extra blog post behavior.
  #
  # This module contains functions for ...
  #
  module BloggingExtra
    include Nanoc::Toolbox::Helpers::HtmlTag
    
    
    # Enables blog post behavior and extra meta data to items
    # in a specific directory ('_posts' by default) or directories
    def add_post_attributes
      @config[:post_dirs] ||= ['_posts', '_articles']
      items.each do |item|
        # check the item's parent directory against the post_dirs
        if @config[:post_dirs].include? File.dirname(item[:filename]).split('/').last
          act_as_post(item)
        end
      end
    end
    
    
    # Enable blog post behavior on an item
    def act_as_post(item)
      fname = File.basename(item[:filename], (item[:extension]))

      # get the date from the filename
      year, month, day = fname.split("-", 4)[0..2]

      # Strip the date from the filename
      item[:slug] = fname.sub(/^\d+-\d+-\d+-/,'')

      # Set creation date param from the values in the filename
      item[:created_at] = Time.local(year, month, day)

      # Add additional meta data
      item[:year] = year
      item[:month] = month
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


    # Formats the item's created_at date accourding to given date format string.
    # The format defaults to @config[:date_format]
    def time_for(item, format=nil)
      format ||= @config[:date_format]
      item[:created_at].strftime(format) unless item[:created_at].nil?
    end


    # Returns n number of recent posts
    # TODO: add current post option, and remove it from the returned list
    def recent_posts(count=5, current_item=nil)
      @sorted_articles ||= sorted_articles

      if (current_item && @sorted_articles.include?(current_item))
        # TODO: remove current_item
      end

      return @sorted_articles[0, count-1]
    end


    #=> { 2011 => { 12 => [item0, item1], 3 => [item0, item2]}, 2010 => {12 => [...]}}
    def posts_by_year_month
      result = {}
      current_year = current_month = year_h = month_a = nil

      sorted_articles.each do |item|
        d = item[:created_at]
        if current_year != d.year
          current_month = nil
          current_year = d.year
          year_h = result[current_year] = {}
        end

        if current_month != d.month
          current_month = d.month
          month_a = year_h[current_month] = [] 
        end

        month_a << item
      end

      result
    end
  end
end
