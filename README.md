# nanoc-toolbox

[![Gem Version](https://badge.fury.io/rb/nanoc-toolbox.png)](http://badge.fury.io/rb/nanoc-toolbox)
[![Build Status](https://travis-ci.org/aadlani/nanoc-toolbox.png)](http://travis-ci.org/aadlani/nanoc-toolbox)
[![Dependency Status](https://gemnasium.com/aadlani/nanoc-toolbox.png)](https://gemnasium.com/aadlani/nanoc-toolbox)
[![Coverage Status](https://coveralls.io/repos/aadlani/nanoc-toolbox/badge.png)](https://coveralls.io/r/aadlani/nanoc-toolbox)
[![Code Climate](https://codeclimate.com/github/aadlani/nanoc-toolbox.png)](https://codeclimate.com/github/aadlani/nanoc-toolbox)

## Presentation

The nanoc-toolbox is a collection of filters and helpers for the static site generator tool nanoc.
I have created this gem for my personal need on [my blog/resume website]( http://anouar.adlani.com ).
If you feel something's missing, feel free to contribute.

## Features

### Helpers

 * **Navigation**: Menu, Breadcrumb, Table of contents, 
 * **Gravatar**: Avatar Using the Gravatar System
 * **HtmlTag**: HTML Tag helper for other helpers
 * **Google UA**: Generate the JS code snipet for Universal Analytics
 * **Google Analytics**: Generate the JS code snipet for Analytics
 * **Blogging Extra**: Add extra blog post behavior
 * **Tagging Extra**: Add extra tagging behavior
 * **Disqus**: Disqus comments helper
 * **Github Gist**: Github Gist helper

### Filters

 * **AddSection**: Section div's based on headers
 * **HtmlTidy**: Clean up the generated html code with Nokogiri
 * **JS Minify**: Minifies the JS files using JSMin

## Requirements and compatibility

 * **ruby >= 1.9.3**: This gem has been tested against ruby 1.9.3, 2.0.0, 2.1.0
 * **nanoc**: It requires obviously the Nanoc gem
 * **Nokogiri**: For the HTML Tidy Filter
 * **jsmin**: For the JS Minify Filter

## Installation

To use the nanoc-toolbox, you have to start by installing the gem.

    gem install nanoc-toolbox

Then require the project main file in your default.rb file in the lib directory of your nanoc project.

```ruby
require "nanoc/toolbox"
```

And the last step is to include the required helper or filter, anywhere in the lib directory of your lib directory.
The usage wants you to put it in the default.rb or the helpers.rb file. 

The following example shows a sample `helpers_.rb` file in the lib directory

```ruby
# Default Helpers provided By Nanoc
include Nanoc3::Helpers::Blogging
include Nanoc3::Helpers::Breadcrumbs

# Custom Helpers
include Nanoc::Toolbox::Helpers::Navigation
include Nanoc::Toolbox::Helpers::Gravatar
```

## Documentation

### API Documentation

The API documentation could be found on [RubyDoc.info](http://rubydoc.info/github/aadlani/nanoc-toolbox/frames)

### Usage Guides

Some usage guides could be found on the [GitHub wiki](https://github.com/aadlani/nanoc-toolbox/wiki)

## Acknowledgments

All the people in [this list](https://github.com/aadlani/nanoc-toolbox/contributors)

## Author

* Anouar ADLANI <anouar@adlani.com>

## Changelog

See the [CHANGELOG](https://github.com/aadlani/nanoc-toolbox/blob/master/CHANGELOG.md) file for details.


## License

Copyright (c) 2011 Anouar ADLANI, nanoc-toolbox is released under the MIT license.
See the [LICENSE](https://github.com/aadlani/nanoc-toolbox/blob/master/LICENSE.md) file for details.
