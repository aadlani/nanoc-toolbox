module Nanoc::Toolbox::Helpers

  # NANOC Helper for the Navigation related stuff.
  # This module contains functions for generating navigation menus for your
  # pages, like navigation menu, breadcrumbs or a table of content for a given Item
  #
  # @author Anouar ADLANI <anouar@adlani.com>
  module Navigation

    # Generate a navigation menu for a given item. 
    # The menu will be generated form the identifier of the desired root element. 
    # The root itself will not be rendered. It generate the menu by parsing all 
    # the descendent of the passed item.
    # 
    # @param  [String]  identifier - the identifier string of the root element
    # @param  [Hash]    params - The Optional parameters
    # @option params [Interger] :depth (3) maximum depth of the rendered menu
    # @option params [String] :collection_tag ('ol') collection englobing tag name
    # @option params [String] :item_tag ('li') item englobing tag name
    # 
    # @return [String] The output ready to be displayed by the caller
    def navigation_for(identifier, params={})
      # Parse params or set to default values
      params[:depth]            ||= 3
      params[:collection_tag]   ||= 'ol'
      params[:item_tag]         ||= 'li'
    
      # Decrease the depth level
      params[:depth] -= 1
    
      # Get root item for which we need to draw the navigation
      root = @items.find { |i| i.identifier == identifier }
    
      # Do not render if there is no child
      return nil unless root.children
    
      # Find all sections, and render them
      sections = find_item_tree(root)
      render_menu(sections, params)
    end
  
  
    # Generate a Table of Content for a given item. The toc will be generated
    # form the item content. The parsing is done with Nokogiri through XPath.
    # 
    # @param  [String]  item_rep - the representation of desired item
    # @param  [Hash]    params - The Optional parameters
    # @option params [Interger] :depth (3) maximum depth of the rendered menu
    # @option params [String] :collection_tag ('ol') collection englobing tag name
    # @option params [String] :item_tag ('li') item englobing tag name
    # 
    # @return [String] The output ready to be displayed by the caller
    #
    # @see http://nokogiri.org/
    def toc_for(item_rep, params={})
      require 'nokogiri'
      
      # Parse params or set to default values
      params[:depth]            ||= 3
      params[:collection_tag]   ||= 'ol'
      params[:item_tag]         ||= 'li'
      params[:path]             ||= 'div[@class="section"]'
      
      # Retreive the parsed content and init nokogiri
      compiled_content = item_rep.instance_eval { @content[:pre] }
      doc = Nokogiri::HTML(compiled_content)
      doc_root = doc.xpath('/html/body').first
      
      # Find all sections, and render them
      sections = find_toc_sections(doc_root, "#{params[:path]}", 2)
      render_menu(sections, params)
    end
  
  
    # Generate a Breadcrumb for a given item. The breadcrumbs, is starting with 
    # the root item and ending with the item itself. 
    #
    # Requires the Helper: Nanoc3::Helpers::Breadcrumbs
    # 
    # @param  [String]  identifier - the identifier string of element
    # @param  [Hash]    params - The Optional parameters
    # @option params [String] :collection_tag ('ol') collection englobing tag name
    # @option params [String] :item_tag ('li') item englobing tag name
    # 
    # @return [String] The output ready to be displayed by the caller
    #
    # @see Nanoc3::Helpers::Breadcrumbs#breadcrumbs_for_identifier
    def breadcrumb_for(identifier, params={})
    
      # Parse params or set to default values
      params[:collection_tag]   ||= 'ul'
      params[:item_tag]         ||= 'li'
    
      # Retreive the breadcrumbs trail and format them
      sections = find_breadcrumbs_trail(identifier)
      render_menu(sections, params)
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
    # @param  [Hash]    params - The Optional parameters
    # @option params [String] :collection_tag ('ol') collection englobing tag name
    # @option params [String] :item_tag ('li') item englobing tag name
    # 
    # @return [String] The output ready to be displayed by the caller
    def render_menu(items, params={})

      # Parse params or set to default values
      params[:depth]            ||= 3
      params[:collection_tag]   ||= 'ol'
      params[:item_tag]         ||= 'li'
    
      # Decrease the depth level
      params[:depth] -= 1
    
      rendered_menu = items.map do |item|
        
        # Render only if there is depth left
        if params[:depth].to_i  >= 0 && item[:subsections]
          output = render_menu(item[:subsections], params) 
          params[:depth] += 1 # Increase the depth level after the call of navigation_for
        end
        output ||= ""
        content_tag(params[:item_tag], link_to(item[:title], item[:link]) + output)
        
      end.join()
      
      content_tag(params[:collection_tag], rendered_menu)
    end
  
    private

      # Really basic Helper Method that wrap a content within an HTML Tag
      def content_tag(name, content="", &block)
        "<#{name}>#{content}</#{name}>"
      end
    
      # Recursive method that extract from an XPath pattern the document structure 
      # and return the "permalinks" to each sections in an Array of Hash that 
      # could be used by the rendering method. The structure is deducted by the 
      # H1-6 header within the html element defined by the XPATH
      def find_toc_sections(section, section_xpath, title_level=1)
        return {} unless section.xpath(section_xpath)
      
        # For each section found call the find_toc_sections on it with an 
        # increased header level (ex: h1 => h2) and then generate the hash res
        sections = section.xpath(section_xpath).map do |subsection|
          header = subsection.xpath("h#{title_level}").first
          sub_id = subsection['id']
          sub_title = header.inner_html if header
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
      def find_item_tree(root)
        return nil unless root.children
      
        # For each child call the find_item_tree on it and then generate the hash
        sections = root.children.map do |child|
          subsections = find_item_tree(child) 

          { :title        => (child[:title] || child.identifier), 
            :link         => relative_path_to(child),
            :subsections  => subsections }
        end
      end
      
      
      def find_breadcrumbs_trail(root)      
        sections = breadcrumbs_for_identifier(root).map do |child|
          { :title        => (child[:title] || child.identifier), 
            :link         => relative_path_to(child),
            :subsections  => nil }
        end
      end
  end
end
