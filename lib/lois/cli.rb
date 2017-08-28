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

      if system('bundle exec rubocop -f p -o lois/rubocop.html')
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

      output = `bundle exec bundle-audit check --verbose --update`
      result = $CHILD_STATUS
      File.write("lois/bundler-audit.log", output)
      puts output

      if result.success?
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

    desc 'brakeman', 'Run brakeman'
    method_option :github_credentials,
      aliases: '-g',
      required: true,
      desc: 'Github credentials to log PR Status.'
    method_option :ci,
      default: 'circleci',
      aliases: '-c',
      desc: 'CI to load env vars from.'
    def brakeman
      puts 'Checking brakeman'
      configure(options)
      if system('bundle exec brakeman -o lois/brakeman.html -o /dev/stdout')
        Lois.config.github.success('brakeman', 'No rails vulnerabilities found.')
      else
        Lois.config.github.failure('brakeman', 'Rails vulnerabilities found.')
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

        Dir.mkdir('lois') unless Dir.exist?('lois')

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
