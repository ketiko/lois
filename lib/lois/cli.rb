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

      if system('rubocop -f html -o lois/rubocop.html -f p')
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

      output = `bundle-audit check --verbose --update`
      result = $CHILD_STATUS
      File.write('lois/bundler-audit.log', output)
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

      system('reek -f html > lois/reek.html')
      if system('reek -n --sort-by smelliness')
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
      if system('brakeman -o lois/brakeman.html -o /dev/stdout')
        Lois.config.github.success('brakeman', 'No rails vulnerabilities found.')
      else
        Lois.config.github.failure('brakeman', 'Rails vulnerabilities found.')
      end
    end

    desc 'simplecov', 'Run simplecov'
    method_option :github_credentials,
                  aliases: '-g',
                  required: true,
                  desc: 'Github credentials to log PR Status.'
    method_option :ci,
                  default: 'circleci',
                  aliases: '-c',
                  desc: 'CI to load env vars from.'
    method_option :minimum,
                  aliases: '-m',
                  desc: 'Minimum required coverage percentage'
    method_option :actual,
                  aliases: '-a',
                  desc: 'Actual required coverage percentage'
    def simplecov
      puts 'Checking simplecov'
      configure(options)

      actual = options[:actual].to_f
      actual_formatted = format('%.2f%', actual)

      if actual >= options[:minimum].to_f
        Lois.config.github.success('simplecov', "#{actual_formatted} coverage.")
      else
        Lois.config.github.failure('simplecov', "#{actual_formatted} is too low.")
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
