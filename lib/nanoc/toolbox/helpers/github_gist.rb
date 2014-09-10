module Nanoc::Toolbox::Helpers

  # NANOC Helper for Github Gists
  #
  # This module contains helper functions to embed gists to your content
  #
  # @see https://gist.github.com/
  #
  # @author Anouar ADLANI <anouar@adlani.com>
  module GithubGist
    include Nanoc::Toolbox::Helpers::HtmlTag

    # GIST script base URL
    GIST_HOST = "https://gist.github.com"
    GIST_EXT  = "js"

    # Generates the script tag for the supplied Gist ID
    # optionaly displays only the specified file
    #
    # @example
    #   gist(1)
    #   #=> <script src="https://gist.github.com/1.js"> </script>
    #   gist(1, "gistfile1.txt")
    #   #=> <script src="https://gist.github.com/1.js?file=gistfile1.txt"></script>
    #
    # @param [Integer] gist_id - the ID of the Gist
    # @param [String] filename - the optional filename to display
    def gist(gist_id, filename=nil)
      raise ArgumentError, "Gist ID should be a hex number" unless (gist_id.to_s).match(/^\h+$/)
      url = "#{GIST_HOST}/#{gist_id}.#{GIST_EXT}"

      if filename
        raise ArgumentError, "Filename should be a string" unless filename.is_a? String
        url += "?file=#{filename}"
      end

      content_tag :script, "", :src => url
    end
  end
end
