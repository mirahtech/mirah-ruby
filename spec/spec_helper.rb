# frozen_string_literal: true

require 'bundler/setup'
require 'mirah'

require 'webmock'
require 'vcr'

Dir[File.dirname(__FILE__) + '/support/**/*.rb'].sort.each { |f| require f }

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # If environment variables have been supplied to allow VCR to hit a real Mirah test endpoint, allow connect.
  if ENV['VCR_HOST']
    WebMock.allow_net_connect!
  else
    WebMock.disable_net_connect!
  end
end

VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  config.hook_into :webmock

  config.default_cassette_options = { record: :new_episodes, match_requests_on: %i[body] }

  config.filter_sensitive_data('<API_USER_ID>') do |interaction|
    interaction.request.headers['Api-User-Id']&.first
  end

  config.filter_sensitive_data('<API_TOKEN>') do |interaction|
    interaction.request.headers['Api-Key']&.first
  end
end
