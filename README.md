# SuperAGI

[![Gem Version](https://badge.fury.io/rb/superagi.svg)](https://badge.fury.io/rb/superagi)
[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/alexrudall/superagi/blob/main/LICENSE.txt)
[![CircleCI Build Status](https://circleci.com/gh/alexrudall/superagi.svg?style=shield)](https://circleci.com/gh/alexrudall/superagi)

Use the [SuperAGI API](https://superagi.com/docs/) with Ruby! 🦄❤️

Create and Manage Agents in your Ruby app...

🚢 Hire me: [peaceterms.com](https://railsai.com?utm_source=superagi&utm_medium=readme&utm_id=26072023)

[🎮 Ruby AI Builders Discord](https://discord.gg/k4Uc224xVD) | [🐦 Twitter](https://twitter.com/alexrudall) | [🤖 OpenAI Gem](https://github.com/alexrudall/ruby-openai) | [🧠 Anthropic Gem](https://github.com/alexrudall/anthropic) | [🚂 Midjourney Gem](https://github.com/alexrudall/midjourney)

### Bundler

Add this line to your application's Gemfile:

```ruby
gem "superagi"
```

And then execute:

```bash
$ bundle install
```

### Gem install

Or install with:

```bash
$ gem install superagi
```

and require with:

```ruby
require "superagi"
```

## Usage

- Get your API key from [https://app.superagi.com/](https://app.superagi.com/)
- Click Go to settings, API Keys, Create Key

### Quickstart

For a quick test you can pass your token directly to a new client:

```ruby
client = SuperAGI::Client.new(secret_key: "secret_key_goes_here")
```

### With Config

For a more robust setup, you can configure the gem with your API keys, for example in an `superagi.rb` initializer file. Never hardcode secrets into your codebase - instead use something like [dotenv](https://github.com/motdotla/dotenv) to pass the keys safely into your environments.

```ruby
SuperAGI.configure do |config|
    config.secret_key = ENV.fetch("SUPERAGI_SECRET_KEY")
end
```

Then you can create a client like this:

```ruby
client = SuperAGI::Client.new
```

You can still override the config defaults when making new clients; any options not included will fall back to any global config set with SuperAGI.configure. e.g. in this example the request_timeout, etc. will fallback to any set globally using SuperAGI.configure, with only the secret_key overridden:

```ruby
client = SuperAGI::Client.new(secret_key: "secret_key_goes_here")
```

#### Custom timeout or base URI

The default timeout for any request using this library is 120 seconds. You can change that by passing a number of seconds to the `request_timeout` when initializing the client. You can also change the base URI used for all requests, eg. if you're running SuperAGI locally with the default `docker-compose` setup you can use `http://superagi-backend-1:8001/`.

```ruby
client = SuperAGI::Client.new(
    secret_key: "secret_key_goes_here",
    uri_base: "http://superagi-backend-1:8001/",
    request_timeout: 240,
    extra_headers: {
      "Extra-Header" => "43200",
    }
)
```

or when configuring the gem:

```ruby
SuperAGI.configure do |config|
    config.secret_key = ENV.fetch("SUPERAGI_SECRET_KEY")
    config.uri_base = "http://superagi-backend-1:8001/" # Optional
    config.request_timeout = 240 # Optional
    config.extra_headers = {
      "abc" => "123",
      "def": "456",
    } # Optional
end
```

### Create Agent

An agent is the primary entity in SuperAGI that carries out tasks. To create one:

```ruby
response = client.agent.create(
    parameters: {
      name: "Motivational Quote Generator",
      description: "Generates motivational quotes",
      goal: ["I need a motivational quote"],
      instruction: ["Write a new motivational quote"],
      iteration_interval: 500,
      max_iterations: 2,
      constraints: [],
      tools: []
    })
puts response
# => {"agent_id"=>15312}
```

### Update Agent

To update an agent, pass the ID and 1 or more of the parameters you want to update:

```ruby
response = client.agent.update(
    id: 15312,
    parameters: {
      name: "Updated name",
    })
puts response
# => {"agent_id"=>15312}
```

### Run Agent

To run an agent:

```ruby
response = client.agent.run(id: 15312)
puts response
# => {"run_id"=>29970}
```

### Pause Agent

To pause an agent:

```ruby
client.agent.run(id: 15312)
response = client.agent.pause(id: 15312)
puts response
# => {"result"=>"success"}
```

### Resume Agent

To resume an agent:

```ruby
client.agent.run(id: 15312)
client.agent.pause(id: 15312)
response = client.agent.resume(id: 15312)
puts response
# => {"result"=>"success"}
```

### Agent Status

To get the status of Agent runs:

```ruby
response = client.agent.status(id: 15312)
puts response
# => [{"run_id"=>29970,"status"=>"CREATED"}]
```

### Agent Resources

To get the resources output by Agent runs:

```ruby
  run_id = client.agent.run(id: 15312)["run_id"]
  response = client.agent.resources(parameters: { run_ids: [run_id] })
  puts response
  # => {}
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

### Warning

If you have an `SUPERAGI_SECRET_KEY` in your `ENV`, running the specs will use this to run the specs against the actual API, which will be slow and cost you money - 2 cents or more! Remove it from your environment with `unset` or similar if you just want to run the specs against the stored VCR responses.

## Release

First run the specs without VCR so they actually hit the API. This will cost 2 cents or more. Set SUPERAGI_SECRET_KEY in your environment or pass it in like this:

```
SUPERAGI_SECRET_KEY=123abc bundle exec rspec
```

Then update the version number in `version.rb`, update `CHANGELOG.md`, run `bundle install` to update Gemfile.lock, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at <https://github.com/alexrudall/superagi>. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/alexrudall/superagi/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Ruby SuperAGI project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/alexrudall/superagi/blob/main/CODE_OF_CONDUCT.md).
