# Service::Status

Provides an object representing the status of a service, suitable for exposing
as JSON as part of a REST api.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'service-status'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install service-status

## Usage

```ruby
status = ServiceStatus::Status.new("windows", '3.11', @@boot_time) # @@boot_time is time the app was started

# check that we can connect to redis
redis_ok = true
begin
	Redis.new.ping
rescue
	redis_ok = false
end

status.add_check('redis', redis_ok)      

JSON.pretty_generate(status)             # render as JSON as required
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/service-status/fork )
2. git flow init -d (assuming you have git flow)
2. Create your feature branch (`git flow feature start my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin feature/my-new-feature`)
5. Create a new Pull Request

## Copyright

Copyright (c) 2015 The Book People

See LICENSE (GPLv3)
