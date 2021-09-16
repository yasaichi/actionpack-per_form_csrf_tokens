# actionpack-per_form_csrf_tokens

[![Gem Version](https://badge.fury.io/rb/actionpack-per_form_csrf_tokens.svg)](http://badge.fury.io/rb/actionpack-per_form_csrf_tokens)
[![Test](https://github.com/yasaichi/actionpack-per_form_csrf_tokens/actions/workflows/test.yml/badge.svg)](https://github.com/yasaichi/actionpack-per_form_csrf_tokens/actions/workflows/test.yml)
[![Test Coverage](https://api.codeclimate.com/v1/badges/1659305c3b9000435d8c/test_coverage)](https://codeclimate.com/github/yasaichi/actionpack-per_form_csrf_tokens/test_coverage)
[![Maintainability](https://api.codeclimate.com/v1/badges/1659305c3b9000435d8c/maintainability)](https://codeclimate.com/github/yasaichi/actionpack-per_form_csrf_tokens/maintainability)

`actionpack-per_form_csrf_tokens` is a backport of per-form CSRF tokens (introduced in Rails 5) into Rails 4.2.  
Note that this gem only adds some patches into `ActionController::Base` to "accept" new-format tokens, because it's aimed for enabling Rails 4.2 apps to exchange them with Rails 5.x or higher ones.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'actionpack-per_form_csrf_tokens'
```

And then execute:

    $ bundle

## Usage

You don't need anything other than install.

## Contributing

You should follow the steps below.

1. [Fork the repository](https://help.github.com/articles/fork-a-repo/)
2. Create a feature branch: `git checkout -b add-new-feature`
3. Commit your changes: `git commit -am 'Add new feature'`
4. Push the branch: `git push origin add-new-feature`
5. [Send us a pull request](https://help.github.com/articles/about-pull-requests/)

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
