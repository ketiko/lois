require 'httparty'

module Lois
  class Github
    Status = Struct.new(:state, :context, :description, :artifact_url)

    attr_reader :credentials, :organization, :repository, :pull_request_sha

    def initialize(credentials, organization, repository, pull_request_sha)
      @credentials = credentials
      @organization = organization
      @repository = repository
      @pull_request_sha = pull_request_sha
    end

    def pending(context, description, artifact_url = nil)
      update_status(Status.new('pending', context, description, artifact_url))
    end

    def success(context, description, artifact_url = nil)
      update_status(Status.new('success', context, description, artifact_url))
    end

    def failure(context, description, artifact_url = nil)
      update_status(Status.new('failure', context, description, artifact_url))
    end

    def pull_request_status_api_url
      @pull_request_status_api_url ||= File.join(
        'https://api.github.com/repos',
        organization,
        repository,
        'statuses',
        pull_request_sha
      )
    end

    private

    def update_status(status)
      username, password = credentials.split(':')
      auth = { username: username, password: password }
      body = {
        state: status.state,
        context: status.context,
        description: status.description
      }
      body[:target_url] = status.artifact_url if status.artifact_url
      response = ::HTTParty.post(pull_request_status_api_url, basic_auth: auth, body: body.to_json)
      return if  response.success?

      puts "Failed to update github: #{response.code}-#{response.body}"
    end
  end
end
