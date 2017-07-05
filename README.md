
[![Build Status](https://travis-ci.org/saberespoder/peanut_labs.svg?branch=master)](https://travis-ci.org/saberespoder/peanut_labs)
[![Gem Version](https://badge.fury.io/rb/peanut_labs.svg)](https://badge.fury.io/rb/peanut_labs)

# PeanutLabs
This is a helper library for PeanutLabs.com integration.

Currently features include:
- Building iframe for survey wall
- Building DirectLinks
- Whitelisting routes in rails

Documentation is here: http://peanut-labs.github.io/publisher-doc/index.html

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'peanut_labs'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install peanut_labs

## Usage
You need to provide you app_id and and app_key.
Perfect place to do that in rails app is config/initialize/peanutlabs.rb file

```
PeanutLabs::Credentials.id = <YOUR APP ID>
PeanutLabs::Credentials.key = <YOUR KEY>
```

### Whitelist

You would need callback in your app to receive response from peanutlabs.
To do that securely, you need to whitelist your route in rails routes.rb file, like this:

```
require 'peanut_labs/whitelist'
post "callback/peanutlabs" => "callback#peanutlabs", constraints: PeanutLabs::Whitelist
```

Whitelist was taken from official documentation:
http://peanut-labs.github.io/publisher-doc/index.html#ipwhitelist

### Iframe

```
ruby
PeanutLabs::Builder::IframeUrl.call(id: user.pid)
```

*Possible attributes*

id: required, public user ID (highly recommended not to expose descending IDs in here)
dob: not required, classes accepted - Date, DateTime, Time or formatted "MM-DD-YYYY" string
sex: not required, 1 for male, 2 for female

### Direct Links

```
ruby
PeanutLabs::Builder::DirectLink.call(user.pid, attributes = {})
```

*Possible attributes (not required)*

payload: a hash with user data attributes for encryption
sub_id: a secure session id. Will be returned during postback notification
zl: survey language (for some reason, PN translates only interface but not questions)


## Development

Be a good lad and write specs, we love code we can rely on.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/saberespoder/peanut_labs.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
