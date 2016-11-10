[![Lucian framework](http://i216.photobucket.com/albums/cc229/gastzar/lucianlogo_1.png)](https://github.com/gastzars/lucian)
[![Lucian framework terminal](http://i216.photobucket.com/albums/cc229/gastzar/out_1.gif)](https://github.com/gastzars/lucian)

[![Build Status](https://travis-ci.org/gastzars/lucian.svg?branch=master)](https://travis-ci.org/gastzars/lucian)

Lucian is a test framework for Docker environments which running up containers using docker-compose.yml, and testing them using Rspec. 

## Installation

You can simply install by:

    $ gem install lucian

## Usage

lucian is run from the command line. Please go to the directory that contain your docker-compose.yml .

### Help

For more information and usage of lucian

```bash
$ lucian --help
```

### Initialize

Simply initialize lucian configuration files.

```bash
$ lucian --init
```

### Start

Just luanch Lucian where you have your docker-compose.yml file and lucian initialized

```bash
$ lucian
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/gastzars/lucian.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

