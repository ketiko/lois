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
        ENV.fetch('TRAVIS_COMMIT')
      end
    end
  end
end
