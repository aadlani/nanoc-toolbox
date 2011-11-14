# nanoc-toolbox

[![Build Status](https://secure.travis-ci.org/aadlani/nanoc-toolbox.png)](http://travis-ci.org/aadlani/nanoc-toolbox)

## Presentation

The nanoc-toolbox is a collection of filters and helpers for the static site generator tool nanoc.

## Features

### Helpers

 * **Navigation**: Menu, Breadcrumb, Table of contents, 
 * **Gravatar**: Avatar Using the Gravatar System
 * **HtmlTag**: HTML Tag helper for other helpers
 * **Google Analytics***: Generate the JS code snipet for Analytics

### Filters

 * **AddSection**: Section div's based on headers
 * **HtmlTidy**: Clean up the generated html code with Nokogiri
 * **JS Minify**: Minifies the JS files using JSMin

## Requirements and compatibility

 * **ruby >= 1.8.7**: This gem has been tested against ruby 1.8.7 and 1.9.2
 * **nanoc3**: It requires obviously the Nanoc gem
 * **Nokogiri**: For the HTML Tidy Filter
 * **jsmin**: For the JS Minify Filter

## Installation

To use the nanoc-toolbox, you have to start by installing the gem.

    gem install nanox-toolbox

Then require the project main file in your default.rb file in the lib directory of your nanoc project.

```ruby
require "nanoc/toolbox"
```

And the last step is to include the required helper or filter, anywhere in the lib directory of your lib directory.
The usage wants you to put it in the default.rb or the helpers.rb file. 

The following example shows a sample helpers_.rb file in the lib directory

```ruby
# Default Helpers provided By Nanoc
include Nanoc3::Helpers::Blogging
include Nanoc3::Helpers::Breadcrumbs

# Custom Helpers
include Nanoc::Toolbox::Helpers::Navigation
include Nanoc::Toolbox::Helpers::Gravatar
```

## Acknowledgments

All the people in [this list](https://github.com/aadlani/nanoc-toolbox/contributors)

## Authors

* Anouar ADLANI <anouar@adlani.com>

## Changelog

See the [CHANGELOG](https://github.com/aadlani/nanoc-toolbox/blob/master/CHANGELOG.md) file for details.


## License

Copyright (c) 2011 Anouar ADLANI, nanoc-toolbox is released under the MIT license.
See the [LICENSE](https://github.com/aadlani/nanoc-toolbox/blob/master/LICENSE.md) file for details.
