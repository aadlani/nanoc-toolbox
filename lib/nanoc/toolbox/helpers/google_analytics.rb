require 'nanoc/toolbox/helpers/html_tag'

module Nanoc::Toolbox::Helpers  
  # NANOC Helper for the Google Analytics JS to add at the end of the layout.
  #
  # This module contains helper functions to generate the JS code snipet
  # used to track your site analytics by simply entering your tracking ID as 
  # parameter or in the configuration file
  #
  # @see http://www.google.com/analytics/
  # @author Anouar ADLANI <anouar@adlani.com>
  module GoogleAnalytics
    include Nanoc::Toolbox::Helpers::HtmlTag
    
    def ga_tracking_snippet(ga_tracking_code=nil)
      ga_tracking_code ||= @config[:ga_tracking_code] || "UA-xxxxxx-x"
      js = <<-EOS
        var _gaq = _gaq || [];
        _gaq.push(['_setAccount', '#{ga_tracking_code}']);
        _gaq.push(['_trackPageview']);

        (function() {
          var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
          ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
          var s  = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
        })();
      EOS
      content_tag('script', js, { :type => 'text/javascript' })
    end
  end
end
