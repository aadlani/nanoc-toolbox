require 'jsmin'

module Nanoc::Toolbox::Filters
  # NANOC Filter for minifying the JS Files
  # using the JSMin gem
  # @see http://rubygems.org/gems/jsmin
  # @author Anouar ADLANI <anouar@adlani.com>
  class JsMinify < Nanoc::Filter
    identifier :js_minify

    def run(content, args = {})
      JSMin.minify(content)
    end
  end
end
