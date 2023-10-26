# SuperAGI

[![Gem Version](https://badge.fury.io/rb/superagi.svg)](https://badge.fury.io/rb/superagi)
[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/alexrudall/superagi/blob/main/LICENSE.txt)
[![CircleCI Build Status](https://circleci.com/gh/alexrudall/superagi.svg?style=shield)](https://circleci.com/gh/alexrudall/superagi)

Use the [SuperAGI API](https://superagi.com/blog/superagi-api/) with Ruby! 🤖❤️

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

The default timeout for any request using this library is 120 seconds. You can change that by passing a number of seconds to the `request_timeout` when initializing the client. You can also change the base URI used for all requests, eg. to use observability tools like [Helicone](https://docs.helicone.ai/quickstart/integrate-in-one-line-of-code), and add arbitrary other headers e.g. for [superagi-caching-proxy-worker](https://github.com/6/superagi-caching-proxy-worker):

```ruby
client = SuperAGI::Client.new(
    secret_key: "secret_key_goes_here",
    uri_base: "https://oai.hconeai.com/",
    request_timeout: 240,
    extra_headers: {
      "X-Proxy-TTL" => "43200", # For https://github.com/6/superagi-caching-proxy-worker#specifying-a-cache-ttl
      "X-Proxy-Refresh": "true", # For https://github.com/6/superagi-caching-proxy-worker#refreshing-the-cache
      "Helicone-Auth": "Bearer HELICONE_API_KEY", # For https://docs.helicone.ai/getting-started/integration-method/superagi-proxy
      "helicone-stream-force-format" => "true", # Use this with Helicone otherwise streaming drops chunks # https://github.com/alexrudall/superagi/issues/251
    }
)
```

or when configuring the gem:

```ruby
SuperAGI.configure do |config|
    config.secret_key = ENV.fetch("SUPERAGI_SECRET_KEY")
    config.uri_base = "https://app.alternativeapi.com/" # Optional
    config.request_timeout = 240 # Optional
    config.extra_headers = {
      "abc" => "123",
      "def": "456",
    } # Optional
end
```

### Files

Put your data in a `.jsonl` file like this:

```json
{"prompt":"Overjoyed with my new phone! ->", "completion":" positive"}
{"prompt":"@lakers disappoint for a third straight night ->", "completion":" negative"}
```

and pass the path to `client.files.upload` to upload it to SuperAGI, and then interact with it:

```ruby
client.files.upload(parameters: { file: "path/to/sentiment.jsonl", purpose: "fine-tune" })
client.files.list
client.files.retrieve(id: "file-123")
client.files.content(id: "file-123")
client.files.delete(id: "file-123")
```

### Fine-tunes

Upload your fine-tuning data in a `.jsonl` file as above and get its ID:

```ruby
response = client.files.upload(parameters: { file: "path/to/sentiment.jsonl", purpose: "fine-tune" })
file_id = JSON.parse(response.body)["id"]
```

You can then use this file ID to create a fine-tune model:

```ruby
response = client.finetunes.create(
    parameters: {
    training_file: file_id,
    model: "ada"
})
fine_tune_id = response["id"]
```

That will give you the fine-tune ID. If you made a mistake you can cancel the fine-tune model before it is processed:

```ruby
client.finetunes.cancel(id: fine_tune_id)
```

You may need to wait a short time for processing to complete. Once processed, you can use list or retrieve to get the name of the fine-tuned model:

```ruby
client.finetunes.list
response = client.finetunes.retrieve(id: fine_tune_id)
fine_tuned_model = response["fine_tuned_model"]
```

This fine-tuned model name can then be used in completions:

```ruby
response = client.completions(
    parameters: {
        model: fine_tuned_model,
        prompt: "I love Mondays!"
    }
)
response.dig("choices", 0, "text")
```

You can delete the fine-tuned model when you are done with it:

```ruby
client.finetunes.delete(fine_tuned_model: fine_tuned_model)
```

### Image Generation

Generate an image using DALL·E! The size of any generated images must be one of `256x256`, `512x512` or `1024x1024` -
if not specified the image will default to `1024x1024`.

```ruby
response = client.images.generate(parameters: { prompt: "A baby sea otter cooking pasta wearing a hat of some sort", size: "256x256" })
puts response.dig("data", 0, "url")
# => "https://oaidalleapiprodscus.blob.core.windows.net/private/org-Rf437IxKhh..."
```

![Ruby](https://i.ibb.co/6y4HJFx/img-d-Tx-Rf-RHj-SO5-Gho-Cbd8o-LJvw3.png)

### Image Edit

Fill in the transparent part of an image, or upload a mask with transparent sections to indicate the parts of an image that can be changed according to your prompt...

```ruby
response = client.images.edit(parameters: { prompt: "A solid red Ruby on a blue background", image: "image.png", mask: "mask.png" })
puts response.dig("data", 0, "url")
# => "https://oaidalleapiprodscus.blob.core.windows.net/private/org-Rf437IxKhh..."
```

![Ruby](https://i.ibb.co/sWVh3BX/dalle-ruby.png)

### Image Variations

Create n variations of an image.

```ruby
response = client.images.variations(parameters: { image: "image.png", n: 2 })
puts response.dig("data", 0, "url")
# => "https://oaidalleapiprodscus.blob.core.windows.net/private/org-Rf437IxKhh..."
```

![Ruby](https://i.ibb.co/TWJLP2y/img-miu-Wk-Nl0-QNy-Xtj-Lerc3c0l-NW.png)
![Ruby](https://i.ibb.co/ScBhDGB/img-a9-Be-Rz-Au-Xwd-AV0-ERLUTSTGdi.png)

### Moderations

Pass a string to check if it violates SuperAGI's Content Policy:

```ruby
response = client.moderations(parameters: { input: "I'm worried about that." })
puts response.dig("results", 0, "category_scores", "hate")
# => 5.505014632944949e-05
```

### Whisper

Whisper is a speech to text model that can be used to generate text based on audio files:

#### Translate

The translations API takes as input the audio file in any of the supported languages and transcribes the audio into English.

```ruby
response = client.audio.translate(
    parameters: {
        model: "whisper-1",
        file: File.open("path_to_file", "rb"),
    })
puts response["text"]
# => "Translation of the text"
```

#### Transcribe

The transcriptions API takes as input the audio file you want to transcribe and returns the text in the desired output file format.

```ruby
response = client.audio.transcribe(
    parameters: {
        model: "whisper-1",
        file: File.open("path_to_file", "rb"),
    })
puts response["text"]
# => "Transcription of the text"
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
