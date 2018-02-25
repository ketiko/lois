lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lois/version'

Gem::Specification.new do |spec|
  spec.name          = 'lois'
  spec.version       = Lois::VERSION
  spec.authors       = ['Ryan Hansen']
  spec.email         = ['ketiko@gmail.com']

  spec.summary       = 'Lois reports statuses of CI results to Github Commit Statuses.'
  spec.description   = 'Lois reports statuses of CI results to Github Commit Statuses.'
  spec.homepage      = 'https://www.github.com/ketiko/lois'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'awesome_print'
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'dotenv'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rspec_junit_formatter'

  spec.add_dependency 'activesupport'
  spec.add_dependency 'brakeman'
  spec.add_dependency 'bundler-audit'
  spec.add_dependency 'httparty'
  spec.add_dependency 'reek'
  spec.add_dependency 'rubocop'
  spec.add_dependency 'simplecov'
  spec.add_dependency 'thor'
end
