[![Build Status](https://travis-ci.org/tumugi/tumugi-plugin-webhook.svg?branch=master)](https://travis-ci.org/tumugi/tumugi-plugin-webhook) [![Code Climate](https://codeclimate.com/github/tumugi/tumugi-plugin-webhook/badges/gpa.svg)](https://codeclimate.com/github/tumugi/tumugi-plugin-webhook) [![Coverage Status](https://coveralls.io/repos/github/tumugi/tumugi-plugin-webhook/badge.svg?branch=master)](https://coveralls.io/github/tumugi/tumugi-plugin-webhook?branch=master) [![Gem Version](https://badge.fury.io/rb/tumugi-plugin-webhook.svg)](https://badge.fury.io/rb/tumugi-plugin-webhook)

# WebHook plugin for [tumugi](https://github.com/tumugi/tumugi)

tumugi-plugin-webhook is a plugin for integrate various WebHooks and [tumugi](https://github.com/tumugi/tumugi).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tumugi-plugin-webhook'
```

And then execute `bundle install`.

## Task

### Tumugi::Plugin::WebhookTask

`Tumugi::Plugin::WebhookTask` is a task to send a HTTP request for any WebHooks.

#### Parameters

- **url** WebHook URL (string, required)
- **http_method** HTTP method (string, optional, default: "post")
- **body** WebHook body (string or hash, optional, default: `nil`)
- **body_encoding** WebHook body encoding type (string, optional, default: "json")
  - "json": MIME type is `application/json`
  - "url_encoded": MIME type is  `application/x-www-form-urlencoded`

#### Example

```rb
task :main, type: :webhook do
  url "http://httpbin.org/post"
  body {
    { text: "message" }
  }
end
```

## Development

After checking out the repo, run `bundle install` to install dependencies.
Then run `bundle exec rake test` to run the tests.

Run this plugin with tumugi, run

```
$ bundle exec tumugi run -f examples/example.rb main
```

## License

The gem is available as open source under the terms of the [Apache License
Version 2.0](http://www.apache.org/licenses/).
