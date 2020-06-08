# frozen_string_literal: true

require_relative 'lib/mirah/version'

Gem::Specification.new do |spec|
  spec.name          = 'mirah-ruby'
  spec.version       = Mirah::VERSION
  spec.authors       = ['Ben Jones', 'Hugh Barrigan']
  spec.email         = ['integrations@mirah.com']

  spec.summary       = 'Connect to your data on Mirah.'
  spec.description   = 'Connect to your data on Mirah.'
  spec.homepage      = 'https://www.mirah.com'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.3.0')

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://www.mirah.com'
  spec.metadata['changelog_uri'] = 'https://www.mirah.com'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # TODO: verify acceptable versions
  spec.add_dependency 'activesupport', '>= 3.0'
  spec.add_dependency 'graphql-client', '~> 0.16'

  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'rake', '~> 12.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.84.0'
  spec.add_development_dependency 'vcr'
  spec.add_development_dependency 'webmock'
  spec.add_development_dependency 'yard', '~> 0.9.25'
end
