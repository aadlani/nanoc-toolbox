# nanoc-toolbox

!!! THIS LIBRARY IS STILL UNDER DEVELOPMENT !!!

## Presentation

The nanoc-toolbox is a collection of filters and helpers for the static site generator tool nanoc.

## Features

* Navigation Helper
* Gravatar Helper
* HtmlTag Helper

## Requirements

* nanoc3
* Nokogiri

## Installation

To use the nanoc-toolbox, you have to start by installing the gem.

    gem install nanox-toolbox

Then require the project main file in your default.rb file in the lib directory of your nanoc project.

    require "nanoc/toolbox"

And the last step is to include the required helper or filter, anywhere in the lib directory of your lib directory.
The usage wants you to put it in the default.rb or the helpers.rb file. 

The following example shows a sample helpers_.rb file in the lib directory

    # Default Helpers provided By Nanoc
    include Nanoc3::Helpers::Blogging
    include Nanoc3::Helpers::Breadcrumbs

    # Custom Helpers
    include Nanoc::Toolbox::Helpers::Navigation
    include Nanoc::Toolbox::Helpers::Gravatar

## Acknowledgments



## Author

* Anouar ADLANI <anouar@adlani.com>

## Changelog

See the CHANGELOG.rdoc file for details.


## License

Copyright (c) 2011 Anouar ADLANI, nanoc-toolbox is released under the MIT license.
See the LICENSE.md file for details.
