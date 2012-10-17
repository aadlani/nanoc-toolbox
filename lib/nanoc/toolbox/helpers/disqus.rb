require 'nanoc/toolbox/helpers/blogging_extra'

module Nanoc::Toolbox::Helpers

  # NANOC Helper for Disqus comments
  #
  # This module contains functions for ...
  #
  # @see http://disqus.com/
  module Disqus
    include Nanoc::Toolbox::Helpers::HtmlTag
    include Nanoc::Toolbox::Helpers::BloggingExtra

    # Creates an id out of the page slug that disqus uses for an id
    def disqus_id_for(item, options={})
      id = ''
      id += options[:disqus_id_prefix] if options[:disqus_id_prefix]
      id += slug_for(item)
      id.gsub(/-/, '_')
    end

    # @see http://help.disqus.com/customer/portal/articles/472098-javascript-configuration-variables
    def disqus_js_snippet(variables={})
      configuration_variables = ""

      variables.each do |k, v|
        configuration_variables += "var disqus_#{k} = '#{v}';\n" unless v.nil?
      end

      js_string = <<-EOS
        #{configuration_variables}
        (function() {
            var dsq = document.createElement('script'); dsq.type = 'text/javascript'; dsq.async = true;
            dsq.src = 'http://' + disqus_shortname + '.disqus.com/embed.js';
            (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(dsq);
        })();
      EOS

      content_tag('script', js_string, { :type => 'text/javascript' })
    end

    def disqus_nojs_snippet(message=nil)
      message ||= "Please enable JavaScript to view the <a href=\"http://disqus.com/?ref_noscript\">comments powered by Disqus.</a>"
      content_tag('noscript', message)
    end
  end
end
