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

    private

    def configure(options)
      Lois.configure do |config|
        config.github_credentials = options[:github_credentials]

        case options[:ci]
        when 'circleci'
          config.ci = Lois::Ci::Circleci.new
        end

        config.github = Lois::Github.new(
          Lois.config.github_credentials,
          Lois.config.ci.organization,
          Lois.config.ci.repository,
          Lois.config.ci.pull_request_sha
        )
      end
    end
  end
end
