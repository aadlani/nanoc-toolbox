module Nanoc::Toolbox::Helpers
  # NANOC Helper for giving items extra blog post behavior.
  #
  # This module contains features to the default Nanoc::Helpers::Blogging
  # module, like tagging, slug, etc...
  # @author Anouar ADLANI
  module BloggingExtra
    include Nanoc::Helpers::Blogging

    # Enable blog post behavior on all the items located in the post folder(s)
    #
    # @example
    #   # In your config.yaml
    #   # post_dirs: [ 'posts' ]
    #
    #   # In your Rules file
    #   preprocess do
    #     add_post_attributes
    #   end
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
    #
    # @example
    #   items.each do |item|
    #     act_as_post(item)
    #   end
    def act_as_post(item)
      fname = slug_for(item)

      if fname =~ /^\d+-\d+-\d+-/
        # get the date from the filename
        item[:year], item[:month], item[:day] = fname.split("-", 4)[0..2]

        # Set creation date param from the values in the filename
        item[:created_at] = Time.local(item[:year], item[:month], item[:day])

        # Strip the date from the filename
        item[:slug] = fname.sub(/^\d+-\d+-\d+-/,'')
      else
        item[:created_at] ||= Time.now
        item[:created_at] = attribute_to_time(item[:created_at])

        # get the date from
        item[:year]  = item[:created_at].year
        item[:month] = item[:created_at].month
        item[:day]   = item[:created_at].day
      end

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
    #
    # @example
    #   # item[:filename] = "abc def geh.html"
    #   slug_for(item) # => "abc-def-geh"
    def slug_for(item)
      return item[:slug] if item[:slug]

      item[:slug] = File.basename(item[:filename], File.extname(item[:filename]))
      item[:slug].gsub!(/\s+/, '-')
      item[:slug]
    end

    # Returns n number of recent posts, optionally omits the current one
    #
    # @param [Integer] count the number of item to return
    # @param [Nanoc::Item] current_item the current item to exclude from the list
    #
    # #return [Array<Nanoc::Item>] an array of recent items
    def recent_posts(count=5, current_item=nil)
      (sorted_articles - [current_item])[0, count]
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
