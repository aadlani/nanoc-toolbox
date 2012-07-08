require 'nanoc/toolbox/helpers/html_tag'


module Nanoc::Toolbox::Helpers
  # NANOC Helper for giving items extra blog post behavior.
  #
  # This module contains functions for ...
  # @author Anouar ADLANI
  module BloggingExtra
    include Nanoc::Toolbox::Helpers::HtmlTag
    include Nanoc3::Helpers::Blogging

    def add_post_attributes
      @config[:post_dirs] ||= ['_posts', '_articles']
      items.each do |item|
        # check the item's parent directory against the post_dirs
        if (item[:filename] && @config[:post_dirs].include?(File.dirname(item[:filename]).split('/').last))
          act_as_post(item)
        end
      end
    end

    # Enable blog post behavior on an item
    #
    # @param [Nanoc::Item] item the item that will act as a post
    # @return [Nanoc::Item] the adapted item
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

    # Get an item's slug if it has one, or use its filename sans extension
    #
    # @param [Nanoc::Item] item the item that will act as a post
    # @return [String] either the slug specified in the item or generate one
    # @example
    #   # item[:filename] = "abc def geh.html"
    #   slug_for(item) # => "abc-def-geh"
    def slug_for(item)
      return item[:slug] if item[:slug]

      item[:slug] = File.basename(item[:filename], File.extname(item[:filename]))
      item[:slug].gsub!(/\s+/, '-')
      item[:slug]
    end


    # Returns an Array of links to tags in the item, optionally omits the 
    # given tags from the selection
    #
    # @param [Item] item the item from which to extract tags
    # @param [Array<String>] omit_tags tags that should be excluded
    # @param [Item] options the options for the links to be created
    # @option options [String] :tag_pattern ("%%tag%%") The pattern to be replace by the tag name
    # @option options [String] :title ("options[:tag_pattern]") The text that will be in the link
    # @option options [String] :file_extension (".html") The file extension
    # @option options [String] :url_format ("/tags/:tag_pattern:file_extension") The path pattern
    #
    # @return [Array<String>] An array of html links
    # @example 
    #   omited = ['strange_tag']
    #   options = { :tag_pattern => "%%TAGNAME%%", 
    #               :title       => "articles tagged with %%TAGNAME%%", 
    #               :url_format  => "/tags/tag_%%TAGNAME%%.html"}
    #   tag_links_for(item, omited, options) # => ['<a href="/tags/tag_a.html">articles tagged with a</a>', '<a href="/tags/tag_b.html">articles tagged with b</a>']
    def tag_links_for(item, omit_tags=[], options={})
      tags = []
      return tags unless item[:tags]

      options[:tag_pattern]     ||= "%%tag%%"
      options[:title]           ||= options[:tag_pattern]
      options[:file_extension]  ||= ".html"
      options[:url_format]      ||= "/tags/#{options[:tag_pattern]}#{options[:file_extension]}"

      item[:tags].each do |tag|
        unless omit_tags.include? tag
          title = options[:title].gsub(options[:tag_pattern], tag.downcase)
          url = options[:url_format].gsub(options[:tag_pattern], tag.downcase)
          tags << content_tag('a', title, {:href => url})
        end
      end

      return tags
    end
    
    
    # Returns n number of recent posts, optionally omits the current one
    #
    # @param [Integer] count the number of item to return
    # @param [Nanoc::Item] current_item the current item to exclude from the list
    #
    # #return [Array<Nanoc::Item>] an array of recent items
    def recent_posts(count=5, current_item=nil)
      recents = sorted_articles
      recents -= [current_item] if recents.include?(current_item)
      return recents[0, count]
    end
    
    
    # Retreive the list of existing articles grouped by years and months
    #
    # @return [Hash] Items grouped in a hash
    # @example
    #   posts_by_date # => { 2011 => { 12 => [item0, item1], 3 => [item0, item2]}, 2010 => {12 => [...]}}
    def posts_by_date
      Hash[sorted_articles.group_by{|item| item[:year]}.map{ |y, items|
        [y, items.group_by{|i| i[:month]}]}]
    end
  end
end
