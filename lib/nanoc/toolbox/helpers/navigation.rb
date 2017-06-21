require 'nanoc/toolbox/helpers/html_tag'

module Nanoc::Toolbox::Helpers
  # NANOC Helper for the Navigation related stuff.
  #
  # This module contains functions for generating navigation menus for your
  # pages, like navigation menu, breadcrumbs or a table of content for a given Item
  #
  # @author Anouar ADLANI <anouar@adlani.com>
  module Navigation
    include Nanoc::Helpers::LinkTo
    include Nanoc::Helpers::Breadcrumbs
    include Nanoc::Toolbox::Helpers::HtmlTag

    # Generate a navigation menu for a given item.
    # The menu will be generated form the identifier of the desired root element.
    # The root itself will not be rendered. It generate the menu by parsing all
    # the descendent of the passed item.
    #
    # @param  [String]  identifier - the identifier string of the root element
    # @param  [Hash]    options - The Optional parameters
    # @option options (see #render_menu)
    # @option options [String] :kind ('article') The kind of items to display in the menu
    # @option options [Symbol] :sort (nil) Item attribute to use for sorting
    # @option options [Int] :fold_at (nil) Depth at which to exclude items not siblings of current item
    #
    # @return [String] The output ready to be displayed by the caller
    def navigation_for(identifier, options={})
      # Get root item for which we need to draw the navigation
      root = @items.find { |i| i.identifier == identifier }

      # Do not render if there is no child
      return nil unless root && root.children

      # Find all sections, and render them
      sections = find_item_tree(root, options)
      render_menu(sections, options)
    end

    # Generate a Table of Content for a given item. The toc will be generated
    # form the item content. The parsing is done with Nokogiri through XPath.
    #
    # @param  [Nanoc::ItemRep]  item_rep - the representation of desired item
    # @param  [Hash]    options - The Optional parameters
    # @option options (see #render_menu)
    # @option options [String] :path ('div[@class="section"]') Generic XPath for the sections
    #
    # @return [String] The output ready to be displayed by the caller
    #
    # @see http://nokogiri.org/
    def toc_for(item_rep, options={})
      require 'nokogiri'
      item_rep = item_rep.rep_named(:default) if item_rep.is_a? Nanoc::Item

      options[:path]             ||= 'div[@class="section"]'

      # Retreive the parsed content and init nokogiri
      compiled_content = item_rep.instance_eval { @content[:pre] }
      doc = Nokogiri::HTML(compiled_content)
      doc_root = doc.xpath('/html/body').first
      return "" if doc_root.nil?

      # Find all sections, and render them
      sections = find_toc_sections(doc_root, options[:path])
      render_menu(sections, options) || ""
    end

    # Generate a Breadcrumb for a given item. The breadcrumbs, is starting with
    # the root item and ending with the item itself.
    #
    # Requires the Helper: Nanoc::Helpers::Breadcrumbs
    #
    # @param  [String]  identifier - the identifier string of element
    # @param  [Hash]    options - The Optional parameters
    # @option options (see #render_menu)
    #
    # @return [String] The output ready to be displayed by the caller
    #
    # @see Nanoc::Helpers::Breadcrumbs#breadcrumbs_for_identifier
    def breadcrumb_for(identifier, options={})
      options[:collection_tag]   ||= 'ul'
      options[:collection_class] ||= 'breadcrumb'

      # Retreive the breadcrumbs trail and format them
      sections = find_breadcrumbs_trail(identifier)
      render_menu(sections, options)
    end

    # Render a Hash to a HTML List by default
    #
    # Hash structure should be construct like this:
    #
    #   Link: is an hash with the following key
    #         - :title       => The content of the link
    #         - :link        => The link
    #         - :subsections => nil or an Array of Links
    #
    #   [{:title => 'Title', :link => 'http://example.com', :subsections =>  [{}, {}, ...]},{...}]
    #
    # Results to an output like the following (by default):
    #   <ul>
    #     <li>
    #       <a href="http://example.com">Title</a>
    #       <ul>
    #         <li><a href="">Title</a></li>
    #       </ul>
    #     </li>
    #     <li><a href="http://example.com">Title</a></li>
    #     <li><a href="http://example.com">Title</a></li>
    #   </ul>
    #
    # @param  [Array]  items - The array of links that need to be rendered
    # @param  [Hash]    options - The Optional parameters
    # @option options [Interger] :depth (3) maximum depth of the rendered menu
    # @option options [String] :collection_tag ('ol') tag englobing collection of items
    # @option options [String] :item_tag ('li') tag englobing item
    # @option options [String] :title_tag ('h2') tag englobing the title
    # @option options [String] :title ('') Title of the menu, if nil will not display title
    # @option options [String] :separator ('') Menu item separator
    #
    # @return [String] The output ready to be displayed by the caller
    def render_menu(items, options={})
      options[:depth]            ||= 3
      options[:collection_tag]   ||= 'ol'
      options[:collection_class] ||= 'menu'
      options[:item_tag]         ||= 'li'
      options[:title_tag]        ||= 'h2'
      options[:title]            ||= nil
      options[:separator]        ||= ''


      # Parse the title and remove it from the options
      title =  options[:title] ? content_tag(options[:title_tag], options[:title]) : ''
      options.delete(:title_tag)
      options.delete(:title)

      # Decrease the depth level
      options[:depth] -= 1
      rendered_menu = items.map do |item|
        # Render only if there is depth left
        if options[:depth].to_i  > 0 && item[:subsections]
          output = render_menu(item[:subsections], options)
          options[:depth] += 1 # Increase the depth level after the call of navigation_for
        end
        output ||= ""
        content_tag(
          options[:item_tag],
          link_to_unless_current(item[:title], item[:link]) + options[:separator] + output,
          :class => item[:class]
        )

      end.join()
      title + content_tag(options[:collection_tag], rendered_menu, :class => options[:collection_class]) unless rendered_menu.strip.empty?
    end

  private

    # Recursive method that extract from an XPath pattern the document structure
    # and return the "permalinks" to each sections in an Array of Hash that
    # could be used by the rendering method. The structure is deducted by the
    # H1-6 header within the html element defined by the XPATH
    def find_toc_sections(section, section_xpath, title_level=1)
      return {} unless section.xpath(section_xpath)

      # For each section found call the find_toc_sections on it with an
      # increased header level (ex: h1 => h2) and then generate the hash res
      sections = section.xpath(section_xpath).map do |subsection|
        header = subsection.css("h1, h2, h3, h4, h5, h6").first
        sub_id = subsection['id']
        sub_title = header ? header.inner_html : 'untitled'
        subsections = {}

        if subsection.xpath("#{section_xpath}") && title_level <= 6
          subsections = find_toc_sections(subsection, "#{section_xpath}", title_level+1)
        end
        { :title => sub_title, :link => '#' + sub_id, :subsections =>  subsections }
      end
    end

    # Recursive method that extract from an XPath pattern the document structure
    # and return the "permalinks" in a Array of Hash that could be used by the
    # rendering method
    def find_item_tree(root, options={})
      return nil unless root.children

      # Include root's children if its depth in the tree is less than options[:fold_at]
      # or if it is an ancestor of the current item.
      if (options[:fold_at] and (root.identifier.to_s.count '/') > options[:fold_at] and @item.identifier.to_s.index(root.identifier) != 0)
        return nil
      end

      # filter the elements to contain only the kind requested
      children = options[:kind] ? root.children.select { |item| item[:kind] == options[:kind] } : root.children

      if (options[:sort])
        # Sort items according to each item's sort property or its identifier
        children = children.sort { |x, y|
          (x[options[:sort]] ? x[options[:sort]].to_s : File.basename(x.identifier)) <=>
          (y[options[:sort]] ? y[options[:sort]].to_s : File.basename(y.identifier))
        }
      end

      # For each child call the find_item_tree on it and then generate the hash
      sections = children.map do |child|
        subsections = find_item_tree(child, options)
        {
          :title        => (child[:title] || child.identifier),
          :link         => relative_path_to(child),
          :subsections  => subsections,
          :class        => child.identifier == @item.identifier ? 'selected' : nil,
        }
      end
    end

    def find_breadcrumbs_trail(root)
      trail = ["/"]
      root.split('/').each { |s| trail << trail.last + "#{s}/" unless s.empty? }
      trail.map do |child_identifier|
        child = @items[child_identifier]
        { :title        => (child[:short_title] || child[:title] || child.identifier),
          :link         => relative_path_to(child),
          :subsections  => nil } if child
      end.compact
    end
  end
end
