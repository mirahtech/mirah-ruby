# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task default: :spec

require 'graphql/client'
require 'graphql/client/http'

task :dump_schema do
  http = GraphQL::Client::HTTP.new('http://localhost:3000/integration_api/graphqlschema')
  ::GraphQL::Client.dump_schema(http, 'schema.json')
end

# Run by typing: rake yard

PATH = File.dirname(__FILE__)

require 'yard'

YARD::Rake::YardocTask.new
