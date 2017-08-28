# Lois [![CircleCI](https://circleci.com/gh/ketiko/lois.svg?style=svg)](https://circleci.com/gh/ketiko/lois)

Lois reports statuses of CI results to Github Pull Request Statuses.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'lois'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install lois

## Usage

```
bundle exec lois help

Commands:
  lois brakeman -g, --github-credentials=GITHUB_CREDENTIALS       # Run brakeman
  lois bundler-audit -g, --github-credentials=GITHUB_CREDENTIALS  # Run bundler-audit
  lois help [COMMAND]                                             # Describe available commands or one specific command
  lois reek -g, --github-credentials=GITHUB_CREDENTIALS           # Run reek
  lois rubocop -g, --github-credentials=GITHUB_CREDENTIALS        # Run Rubocop
```

Lois has commands to run and report ruby quality metrics to Github PR Statuses.  All it requires is
a github basic auth credentials for a user to report the statuses.  The user needs write access to the repo to post
PR status updates.

See [https://developer.github.com/v3/auth/#basic-authentication](https://developer.github.com/v3/auth/#basic-authentication).
We recommend using oauth tokens and not your password.

Currently we only support reporting through [CircleCI](https://circleci.com/), but PRs for additional continuous integration systems are welcome.

Lois will output all the results of the checks to a `lois` directory.  You can add this to your artifact path to view the html representation of the results later.

A sample `.circleci/config.yml` would look like:

```
- run:
    name: Bundler-Audit
    command: bin/lois bundler-audit -g $GITHUB_CREDENTIALS

- run:
    name: Brakeman
    command: bin/lois brakeman -g $GITHUB_CREDENTIALS

- run:
    name: Rubocop
    command: bin/lois rubocop -g $GITHUB_CREDENTIALS

- run:
    name: Reek
    command: bin/lois reek -g $GITHUB_CREDENTIALS

- store_artifacts:
    path: lois
    destination: lois
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/lois.
