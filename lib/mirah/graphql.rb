# frozen_string_literal: true

module Mirah
  # Graphql provides the direct interface with the graphql client library and can be used directly to query
  # Mirah endpoints.
  # @private
  module Graphql
    DEFAULT_ENDPOINT = '/integration_api/graphql'

    raw_schema = JSON.parse(File.read(File.dirname(__FILE__) + '/../../schema.json'))
    Schema = GraphQL::Schema::Loader.load(raw_schema)

    # A graplql executor which will supply the correct HTTP headers to authenticate with Mirah servers.
    class AuthorizedHttp < GraphQL::Client::HTTP
      def headers(context)
        {
          "API_USER_ID": context[:user_id],
          "API_KEY": context[:access_token]
        }
      end
    end

    # Create a new Graphql client for the given endpoint, authenticating with the given details.
    def self.create_client(host:)
      http = AuthorizedHttp.new(host + DEFAULT_ENDPOINT)
      GraphQL::Client.new(schema: Schema, execute: http)
    end

    # In order to validate the queries in advance, we need a client, but we don't have an execution context,
    # so we make a validation client to generate the query types.
    ValidationClient = GraphQL::Client.new(schema: Schema)
  end
end
