module Nanoc::Toolbox::Helpers

  # NANOC Helper for the Gravatar avatars
  #
  # This module contains functions for generating URL or IMG tags to 
  # display the Gravatar linked to an address email, or the default gravatar
  #
  # @see http://en.gravatar.com/
  #
  # @author Anouar ADLANI <anouar@adlani.com>
  module Gravatar

    # Gravatar avatar image base URL
    URL = { :http   => "http://gravatar.com/avatar/",
            :https  => "https://secure.gratatar.com/avatar/" }

    # Collection of allowed ratings
    RATING = %w{g pg r x}

    # Default Icon sets
    ICONS = %w{none identicon monsterid wavatar 404}

    # Size range available
    SIZE = 1..512

    # Available options that could be configure
    AVAILABLE_OPTIONS = [:default_icon, :size, :rating, :ext, :secure]

    # Default values set to the options
    DEFAULT_VALUES = { :size => nil, :rating => nil, :ext => false, :secure => false }

    # Generate the image tag to the gravatar of the supplied email
    #
    # @example
    #   gravatar_image('anouar@adlani.com', :size => "100")
    #   #=> <img src="http://gravatar.com/avatar/4d076af1db60b16e1ce080505baf821c?size=100" />
    #
    # @param  [String]  email - the email address of the gravatar account
    # @param  options (see #build_options_parameters)
    # @option options (see #build_options_parameters)
    def gravatar_image(email, options={})
      image_url = gravatar_url(email, options)
      "<img src='#{image_url}' />"
    end


    # Generate image URL
    #
    # @example
    #   gravatar_url('anouar@adlani.com', :size => "512", :ext => true)
    #   #=> "http://gravatar.com/avatar/4d076af1db60b16e1ce080505baf821c.jpg?size=512"
    #
    # @param  email   (see #gravatar_image)
    # @param  options (see #build_options_parameters)
    # @option options (see #build_options_parameters)
    def gravatar_url(email, options={})
      # Prepare the options
      options = DEFAULT_VALUES.merge(options)
      options = clean_options(options)

      # Retreive the URL depending on the protocole and build it
      protocole = options[:secure] ? :https : :http
      host = URL[protocole]

      # generate the image name and append a the extension if requested
      file = hash_email(email)
      file += '.jpg' if options[:ext]

      # Build the query string
      parameters = build_options_parameters(options)

      "#{host}#{file}#{parameters}"
    end

    protected
      # Build the options parameters for the URL. 
      # It simply consists in returning the URL query string based on the options passed
      #
      # @example
      #   {:size => 225, :rating => 'g', :ext => false, :secure => false}
      #   #=> "?size=225&rating=g&ext=false&secure=false"
      #
      # @param [Hash] options the options to pass to the gravatar URL
      # @option options [String] default_icon
      # @option options [String] size (nil) Size of the image, between 1 to 512
      # @option options [String] rating (nil) The rating allowed, a value in g, pg, r or x
      # @option options [Boolean] ext (false) Use or not a file extension
      # @option options [Boolean] secure (false) Use or not https
      def build_options_parameters(options={})
        # Remove unecessary options
        # TODO: Remove the options not related to gravatar (ext, secure, ...)
        
        # Return now if the options hash is empty after cleanup
        return '' if options.empty?

        # Build the parameters string
        '?' + options.to_a.map { |e|  e = e.join('=') if e.size == 2}.join('&')
      end

    private
      # Generate email address hash
      def hash_email(email)
        require 'digest/md5'
        Digest::MD5.hexdigest(email)
      end

      def clean_options(options={})
        options.delete_if {|key, value| value.nil? || value.to_s.empty? }
      end

  end
end
