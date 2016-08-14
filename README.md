# webhook plugin for [tumugi](https://github.com/tumugi/tumugi)

TODO: Write short description here and tumugi-plugin-webhook.gemspec file.

## Target

### Tumugi::Plugin::WebhookTarget

TODO: Write description about `Tumugi::Plugin::WebhookTarget`.

## Task

### Tumugi::Plugin::WebhookTask

TODO: Write description about `Tumugi::Plugin::WebhookTask`.

#### Parameters

- **param1** description (string, required)
- **param2** description (integer, optional, default: 1)

#### Example

```rb
task :main, type: :webhook do
  param1 'value1'
  output { target(:webhook, param1) }
end
```

### Config Section

TODO: Write description about config section named "webhook"
if this plugin has config section.

#### Example

```rb
Tumugi.configure do |config|
  config.section("webhook") do |section|
    section.config1 = "xxx"
  end
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
