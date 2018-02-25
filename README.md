# Lois [![CircleCI](https://circleci.com/gh/ketiko/lois.svg?style=svg)](https://circleci.com/gh/ketiko/lois)

Lois reports statuses of CI results to GitHub Commit Statuses.

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
  lois simplecov -g, --github-credentials=GITHUB_CREDENTIALS      # Run simplecov
```

Lois has commands to run and report ruby quality metrics to GitHub PR Statuses.  All it requires is
a GitHub basic auth credentials for a user to report the statuses.  The user needs write access to the repo to post
PR status updates.

See [https://developer.github.com/v3/auth/#basic-authentication](https://developer.github.com/v3/auth/#basic-authentication).
We recommend using oauth tokens and not your password.

Currently we support reporting through [CircleCI](https://circleci.com/) and [Travis](https://travis-ci.org), but PRs for additional continuous integration systems are welcome.

Lois will output all the results of the checks to a `lois` directory.  You can add this to your artifact path to view the html representation of the results later.

##### CircleCI 2.0
A sample `.circleci/config.yml` would look like:

```
- run:
    name: Bundler-Audit
    command: bundle exec lois bundler-audit -c circleci -g $GITHUB_CREDENTIALS

- run:
    name: Brakeman
    command: bundle exec lois brakeman -c circleci -g $GITHUB_CREDENTIALS

- run:
    name: Rubocop
    command: bundle exec lois rubocop -c circleci -g $GITHUB_CREDENTIALS

- run:
    name: Reek
    command: bundle exec lois reek -c circleci -g $GITHUB_CREDENTIALS

- store_artifacts:
    path: lois
    destination: lois
```

##### CircleCI 1.0
A sample `circle.yml` would look like:
```
test:
  pre:
    - bundle exec lois bundler-audit -c circleci -g $GITHUB_CREDENTIALS
    - bundle exec lois brakeman -c circleci -g $GITHUB_CREDENTIALS
    - bundle exec lois rubocop -c circleci -g $GITHUB_CREDENTIALS
    - bundle exec lois reek -c circleci -g $GITHUB_CREDENTIALS
  post:
    - cp -r lois $CIRCLE_ARTIFACTS/
```

##### Travis
A sample `.travis.yml` would look like:
```
script:
  - bin/lois bundler-audit -c travis -g $GITHUB_CREDENTIALS
  - bin/lois rubocop -c travis -g $GITHUB_CREDENTIALS
  - bin/lois reek -c travis -g $GITHUB_CREDENTIALS
```

### SimpleCov

To get SimpleCov output you must have an `at_exit` hook.  A sample SimpleCov setup looks like:

```
if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start
  SimpleCov.minimum_coverage 55
  SimpleCov.at_exit do
    if ENV['CI']
      min = SimpleCov.minimum_coverage
      actual = SimpleCov.result.covered_percent
      system("lois simplecov -g $GITHUB_CREDENTIALS -m #{min} -a #{actual}")
    end
    SimpleCov.result.format!
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/lois.
