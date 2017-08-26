require 'thor'

module Lois
  class CLI < Thor
    desc 'rubocop', 'Run Rubocop'
    method_option :github_credentials,
                  aliases: '-g',
                  required: true,
                  desc: 'Github credentials to log PR Status.'
    method_option :ci,
                  default: 'circleci',
                  aliases: '-c',
                  desc: 'CI to load env vars from.'
    def rubocop
      puts 'Checking Rubocop'
      configure(options)

      if system('bundle exec rubocop -f p')
        Lois.config.github.success('rubocop', 'Rubocop passed')
      else
        Lois.config.github.failure('rubocop', 'Rubocop failed')
      end
    end

    desc 'bundler-audit', 'Run bundler-audit'
    method_option :github_credentials,
                  aliases: '-g',
                  required: true,
                  desc: 'Github credentials to log PR Status.'
    method_option :ci,
                  default: 'circleci',
                  aliases: '-c',
                  desc: 'CI to load env vars from.'
    def bundler_audit
      puts 'Checking bundler-audit'
      configure(options)

      if system('bundle exec bundle-audit check --verbose --update')
        Lois.config.github.success('bundler-audit', 'No gem vulnerabilities found.')
      else
        Lois.config.github.failure('bundler-audit', 'Gem vulnerabilities detected!')
      end
    end

    desc 'reek', 'Run reek'
    method_option :github_credentials,
                  aliases: '-g',
                  required: true,
                  desc: 'Github credentials to log PR Status.'
    method_option :ci,
                  default: 'circleci',
                  aliases: '-c',
                  desc: 'CI to load env vars from.'
    def reek
      puts 'Checking reek'
      configure(options)
      if system('bundle exec reek -n --sort-by smelliness')
        Lois.config.github.success('reek', 'No code smells.')
      else
        Lois.config.github.failure('reek', 'Code smells found.')
      end
    end

    private

    def configure(options)
      Lois.configure do |config|
        config.github_credentials = options[:github_credentials]

        case options[:ci]
        when 'circleci'
          config.ci = Lois::Ci::Circleci.new
        end

        config.github = Lois::Github.new(
          config.github_credentials,
          config.ci.organization,
          config.ci.repository,
          config.ci.pull_request_sha
        )
      end
    end
  end
end
