# grape_logging

## Installation

Add this line to your application's Gemfile:

    gem 'grape_logging'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install grape_logging

## Basic Usage

In your api file (somewhere on the top)

    logger.formatter = GrapeLogging::Formatters::Default.new
    use GrapeLogging::Middleware::RequestLogger, { logger: logger }


## Features

### Log Format

With the default configuration you will get nice log message

    [2015-04-14 13:54:08 +0200] INFO -- 200 -- total=2.06 db=0.36 -- GET /your_app/endpoint params={some_param: 12}

If you prefer some other format I strongly encourage you to do pull request with new formatter class ;)

### Logging to file and STDOUT

You can to file and STDOUT at the same time, you just need to assign new logger

    logger Logger.new GrapeLogging::MultiIO.new(STDOUT, File.open('path/to/your/logfile.log'), 'a'))

### Logging exceptions

If you want to log exceptions you can do it like this

    class MyAPI < Grape::API
      rescue_from :all do |e|
        MyAPI.logger.error e
        #do here whatever you originally planned to do :)
      end
    end

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/aserafin/grape_logging/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request