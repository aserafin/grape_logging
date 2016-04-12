# grape_logging

[![Code Climate](https://codeclimate.com/github/aserafin/grape_logging/badges/gpa.svg)](https://codeclimate.com/github/aserafin/grape_logging)

## Installation

Add this line to your application's Gemfile:

    gem 'grape_logging'

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install grape_logging

## Basic Usage

In your api file (somewhere on the top)

    require 'grape_logging'
    logger.formatter = GrapeLogging::Formatters::Default.new
    use GrapeLogging::Middleware::RequestLogger, { logger: logger }

**ProTip:** If your logger doesn't support setting formatter you can remove this line - it's optional

## Features

### Log Format

With the default configuration you will get nice log message

    [2015-04-16 12:52:12 +0200] INFO -- 200 -- total=2.06 db=0.36 -- PATCH /your_app/endpoint params={"some_param"=>{"value_1"=>"123", "value_2"=>"456"}}

If you prefer some other format I strongly encourage you to do pull request with new formatter class ;)

You can change the formatter like so

    class MyAPI < Grape::API
      use GrapeLogging::Middleware::RequestLogger, logger: logger, format: MyFormatter.new
    end

### Customising What Is Logged

You can include logging of other parts of the request / response cycle by including subclasses of `GrapeLogging::Loggers::Base`

    class MyAPI < Grape::API
      use GrapeLogging::Middleware::RequestLogger,
        logger: logger,
        include: [ GrapeLogging::Loggers::Response.new,
                   GrapeLogging::Loggers::FilterParameters.new,
                   GrapeLogging::Loggers::ClientEnv.new ]
    end

#### FilterParameters
The `FilterParameters` logger will filter out sensitive parameters from your logs. If mounted inside rails, will use the `Rails.application.config.filter_parameters` by default. Otherwise, you must specify a list of keys to filter out.

#### ClientEnv
The `ClientEnv` logger will add `ip` and user agent `ua` in your log.

### Logging to file and STDOUT

You can log to file and STDOUT at the same time, you just need to assign new logger

    log_file = File.open('path/to/your/logfile.log', 'a')
    log_file.sync = true
    logger Logger.new GrapeLogging::MultiIO.new(STDOUT, log_file)

### Logging via Rails instrumentation

You can choose to not pass the logger to ```grape_logging``` but instead send logs to Rails instrumentation in order to let Rails and its configured Logger do the log job, for example.
First, config ```grape_logging```, like that:

    class MyAPI < Grape::API
      use GrapeLogging::Middleware::RequestLogger,
        instrumentation_key: 'grape_key',
        include: [ GrapeLogging::Loggers::Response.new,
                   GrapeLogging::Loggers::FilterParameters.new ]
    end

and then add an initializer in your Rails project:

    # config/initializers/instrumentation.rb

    # Subscribe to grape request and log with Rails.logger
    ActiveSupport::Notifications.subscribe('grape_key') do |name, starts, ends, notification_id, payload|
      Rails.logger.info payload
    end

The idea come from here: https://gist.github.com/teamon/e8ae16ffb0cb447e5b49

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
