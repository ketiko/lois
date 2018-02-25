module Lois
  module Ci
    class Circleci
      def organization
        ENV.fetch('CIRCLE_PROJECT_USERNAME')
      end

      def repository
        ENV.fetch('CIRCLE_PROJECT_REPONAME')
      end

      def commit_sha
        ENV.fetch('CIRCLE_SHA1')
      end
    end
  end
end
