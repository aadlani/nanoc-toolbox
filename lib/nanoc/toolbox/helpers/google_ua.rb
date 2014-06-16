require 'nanoc/toolbox/helpers/html_tag'

module Nanoc::Toolbox::Helpers
  # NANOC Helper for the Google Universal Analytics JS to add at the end of the
  # layout.
  #
  # This module contains helper functions to generate the JS code snipet
  # used to track your site analytics by simply entering your tracking ID as
  # parameter or in the configuration file
  #
  # @see http://www.google.com/analytics/
  # @author Anouar ADLANI <anouar@adlani.com>
  # @author Basil Peace <grv87@yandex.ru>
  module GoogleUA
    include Nanoc::Toolbox::Helpers::HtmlTag

    # Return the javascript code snipet to use in your layout or views
    #
    # @param [String] ga_tracking_code the Google Analytics Tracking Code
    # @return [String] the script tag to place in your layout
    def ua_tracking_snippet(ga_tracking_code=nil)
      ga_tracking_code ||= @config[:ga_tracking_code] || "UA-xxxxxx-x"
      js = <<-EOS
        (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
        (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
        m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
        })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

        ga('create', '#{ga_tracking_code}', 'auto');
        ga('send', 'pageview');
      EOS
      content_tag('script', js, { :type => 'text/javascript' })
    end
  end
end
