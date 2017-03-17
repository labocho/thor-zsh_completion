# Thor::ZshCompletion

Create zsh completion script for [Thor](http://whatisthor.com/) subclass.


## Feature

This creates completion script that completes...

- Subcommands (includes nested subcommands such as `knife solo cook ...`)
- Options for subcommands.

But...

- Does not support arguments for subcommand, all arguments are completed as file.
- Does not support arguments for options, all arguments are completed as file.


## Installation

Add this line to your application's Gemfile:

    gem 'thor-zsh_completion'


And then execute:

    $ bundle

Or install it yourself as:

    $ gem install thor-zsh_completion


## Usage

To generate completion script:

    require "thor"
    require "thor/zsh_completion"

    class YourCommand < Thor
      # ...
    end

    puts Thor::ZshCompletion::Generator.new(YourCommand, "yourcommand").generate

Or include `Thor::ZshCompletion::Command` to add subcommand `zsh-completion`

    require "thor"
    require "thor/zsh_completion"

    class YourCommand < Thor
      include ZshCompletion::Command
      # ...
    end

    YourCommand.start(ARGV)

and execute below.

    $ yourcommand zsh-completion [--name=yourcommand] > path/to/fpath/_yourcommand


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).


### Testing completion script

    source spec/thor/zsh_completion/generator_spec.zsh
    generator_spec [TAB]

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/thor-zsh_completion. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.



## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

