module Nanoc::Toolbox::Helpers

  # NANOC Helper for added tagging functions
  #
  # This module contains functions for ...
  #
  # @see http://groups.google.com/group/nanoc/browse_thread/thread/caefcab791fd3c4b
  module TaggingExtra
    include Nanoc::Helpers::Blogging

    # Returns all the tags present in a collection of items. The tags are
    # only present once in the returned value. When called whithout
    # parameters, all the site items are considered.
    #
    # @param [Array<Nanoc::Item>] items
    # @return [Array<String>] An array of tags
    def tag_set(items=nil)
      items ||= @items
      items.map { |i| i[:tags] }.flatten.uniq.delete_if{|t| t.nil?}
    end

    # Return true if an item has a specified tag
    #
    # @param [Nanoc::Item] item
    # @param [String] tag
    # @return [Boolean] true if the item contains the specified tag
    def has_tag?(item, tag)
      return false if item[:tags].nil?
      item[:tags].include? tag
    end

    # Finds all the items having a specified tag. By default the method search
    # in all the site items. Alternatively, an item collection can be passed as
    # second (optional) parameter, to restrict the search in the collection.
    #
    # @param [Array<Nanoc::Item>] items
    # @param [String] tag
    # @param [Nanoc::Item] item
    def items_with_tag(tag, items=nil)
      items = sorted_articles if items.nil?
      items.select { |item| has_tag?( item, tag ) }
    end

    # Count the tags in a given collection of items. By default, the method
    # counts tags in all the site items. The result is an hash such as:
    # { tag => count }.
    #
    # @param [Array<Nanoc::Item>] items
    # @return [Hash] Hash indexed by tag name with the occurences as value
    def count_tags(items=nil)
      items ||= @items
      tags = items.map { |i| i[:tags] }.flatten.delete_if{|t| t.nil?}
      tags.inject(Hash.new(0)) {|h,i| h[i] += 1; h }
    end

    # Sort the tags of an item collection (defaults to all site items) in 'n'
    # classes of rank. The rank 0 corresponds to the most frequent tags.
    # The rank 'n-1' to the least frequents. The result is a hash such as:
    # { tag => rank }
    #
    # @param [Integer] n number of rank
    # @param [Array<Nanoc::Item>] items
    def rank_tags(n, items=nil)
      raise ArgumentError, 'the number of ranks should be > 1' if n < 2

      items = @items if items.nil?
      count = count_tags( items )
      min, max = count.values.minmax

      ranker = lambda { |num| n - 1 - (num - min) / (max - min) }

      Hash[count.map {|tag,value| [tag, ranker.call(value) ] }]
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
    #
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

      tags = item[:tags] - omit_tags

      tags.map! do |tag|
          title = options[:title].gsub(options[:tag_pattern], tag.downcase)
          url = options[:url_format].gsub(options[:tag_pattern], tag.downcase)
          content_tag('a', title, {:href => url})
      end
    end

    # Creates in-memory tag pages from tags of the passed items or form all items
    #
    # @param [Array<Item>] item the item from which to extract tags
    # @param [Item] options the options for the item to be created
    # @option options [String] :tag_pattern ("%%tag%%") The pattern to be replace by the tag name
    # @option options [String] :title ("options[:tag_pattern]") The text that will be in the link
    # @option options [String] :identifier ("/tags/option[:tag_pattern]") The item identifer
    # @option options [String] :template ("tag") The template/layout to use to render the tag
    def create_tag_pages(items=nil, options={})
      options[:tag_pattern]     ||= "%%tag%%"
      options[:title]           ||= options[:tag_pattern]
      options[:identifier]      ||= "/tags/#{options[:tag_pattern]}/"
      options[:template]        ||= "tag"

      tag_set(items).each do |tagname|
        raw_content = "<%= render('#{options[:template]}', :tag => '#{tagname}') %>"
        attributes  = { :title => options[:title].gsub(options[:tag_pattern], tagname) }
        identifier  = options[:identifier].gsub(options[:tag_pattern], tagname)

        @items << Nanoc3::Item.new(raw_content, attributes, identifier, :binary => false)
      end
    end
  end
end
