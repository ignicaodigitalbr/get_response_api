# GetResponseApi

This is a simple wrapper for the GetResponse API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'get_response_api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install get_response_api

## Usage

First of all you will need to create an instance of the GetResponse Client with it's api-key:
```ruby
client = GetResponseApi::Client.new('CLIENT API KEY')
```
After this you can call the (API)[https://apidocs.getresponse.com/v3] methods through it.
For example:
```ruby
client.account
# This method will return the client account hash if it succeds and a error message otherwise
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ignicaodigitalbr/get_response_api. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the GetResponseApi project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/ignicaodigitalbr/get_response_api/blob/master/CODE_OF_CONDUCT.md).
