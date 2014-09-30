# Haiku Gadget

Generate random haikus!

Uses an algorithm, a custom dictionary, some grammar rules, and a team of hamsters running in wheels.

## What is a haiku?

A short poem consisting of three lines:

    five syllables here
    then seven syllables here
    then five syllables

## Installation

Add this line to your application's Gemfile:

    gem 'haiku_gadget'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install haiku_gadget

## Usage

First, turn on the gadget:

    require 'haiku_gadget'

Get a random haiku as an array of three lines:

    HaikuGadget.haiku

Or pass in a delimiter, which will return the haiku as a single string:

    HaikuGadget.haiku ' / '

To get a single random line, try one of these methods:

    HaikuGadget.top_line
    HaikuGadget.middle_line
    HaikuGadget.bottom_line

Or specify the line you want by an index:

    HaikuGadget.random_line 0
    HaikuGadget.random_line 1
    HaikuGadget.random_line 2

## Contributing

1. Fork it ( http://github.com/zenblender/haiku_gadget/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
