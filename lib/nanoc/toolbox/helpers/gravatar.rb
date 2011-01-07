module Nanoc::Toolbox::Helpers
  module Gravatar

    # Gravatar avatar image base URL
    URL = { :http   => "http://gravatar.com/avatar/",
            :https  => "https://secure.gratatar.com/avatar/", }

    # Collection of allowed ratings
    RATING = %w{g pg r x}

    # Default Icon sets
    ICONS = %w{none identicon monsterid wavatar 404}

    # Generate the image tag to the gravatar of the supplied email
    #
    # @param  [String]  email - the email address of the gravatar account
    # @param  [Hash]    options - The Optional parameters
    # @option options
    def gravatar_image(email, options={})
      image_url = gravatar_url(email, options={})
      "<img src='#{image_url}'></img>"
    end

    # Generate image URL
    #
    # @param  [String]  email - the email address of the gravatar account
    # @param  [Hash]    options - The Optional parameters
    # @option options
    def gravatar_url(email, options={})
      options = {}.merge options

      # Retreive the URL depending on the protocole and build it
      protocole = options[:secure] ? :https : :http
      url = URL[protocole] + hash_email(email)

      # append a the extension if requested
      url = '.jpg' if options[:ext]
    end


    private
      # Generate email address hash
      def hash_email(email)
        require 'digest/md5'
        Digest::MD5.hexdigest(email_address)
      end
  end
end
