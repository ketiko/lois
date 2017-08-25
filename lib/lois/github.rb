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
      command = curl_start + curl_data(status)
      command = command.join(' ')

      exit 1 unless system(command)
    end

    def curl_start
      [
        "curl --location #{pull_request_status_api_url}",
        "--user #{credentials}",
        '--silent',
        '--request POST',
        "--header \'Content-Type: application/json\'"
      ]
    end

    def curl_data(status)
      command = [
        "--data \'{",
        " \"state\": \"#{status.state}\",",
        " \"context\": \"#{status.context}\",",
        " \"description\": \"#{status.description}\""
      ]
      command << ",\"target_url\": \"#{status.artifact_url}\"" if status.artifact_url
      command << "}\' > /dev/null"
    end
  end
end

