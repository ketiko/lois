require 'active_support/configurable'
require 'lois/version'
require 'lois/github'
require 'lois/ci'
require 'lois/cli'

module Lois
  include ActiveSupport::Configurable

  config_accessor :ci
  config_accessor :github_credentials
  config_accessor :github
end
