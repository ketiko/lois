module Lois
  module Ci
    class Travis
      def organization
        ENV.fetch('TRAVIS_REPO_SLUG').split('/')[0]
      end

      def repository
        ENV.fetch('TRAVIS_REPO_SLUG').split('/')[1]
      end

      def commit_sha
        sha = ENV.fetch('TRAVIS_PULL_REQUEST_SHA')
        sha.length == 0 ? ENV.fetch('TRAVIS_COMMIT') : sha
      end
    end
  end
end
