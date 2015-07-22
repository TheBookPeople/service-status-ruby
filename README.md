# Service::Status

[![Build Status](https://travis-ci.org/TheBookPeople/service-status-ruby.svg)](https://travis-ci.org/TheBookPeople/service-status-ruby) [![Code Climate](https://codeclimate.com/github/TheBookPeople/service-status-ruby/badges/gpa.svg)](https://codeclimate.com/github/TheBookPeople/service-status-ruby) [![Test Coverage](https://codeclimate.com/github/TheBookPeople/service-status-ruby/badges/coverage.svg)](https://codeclimate.com/github/TheBookPeople/service-status-ruby) [![Gem Version](https://badge.fury.io/rb/service-status.svg)](http://badge.fury.io/rb/service-status) [![Gem Dependency](https://img.shields.io/gemnasium/TheBookPeople/service-status-ruby.svg)](https://gemnasium.com/TheBookPeople/service-status-ruby)


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
status = ServiceStatus::Status.new("windows", '3.11', boot_time)
# boot_time is time the app was started

# check that we can connect to redis
redis_ok = true
begin
	Redis.new.ping
rescue
	redis_ok = false
end

#Last argument 'description' is optional
status.add_check('redis', redis_ok, 'Can connect to Redis')

#Last argument 'description' is optional
status.add_stat('request_count', 100, 'Number of Requests')

JSON.pretty_generate(status)             # render as JSON as required
```
## Format

As below. Checks are always part of the 'checks' array. If they have failed,
they are included in 'errors' as well.

'Status' is either "online" or "offline".

```javascript
{
  "name": "windows",
  "version": "3.11",
  "hostname": "clippy",
  "stats": [{
    "name": "request_count",
    "value": 100,
    "description": "Number of Requests"
  }],
  "checks": [{
    "name": "redis",
    "successful": true
    "description": "Can connect to Redis"
  }],
  "timestamp": "2015-05-07 14:35:17",
  "uptime": "14d:23:11:21",
  "diskusage": "64%",
  "status": "online"
}

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
