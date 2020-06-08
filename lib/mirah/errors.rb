# frozen_string_literal: true

module Mirah
  # A top level error from the Mirah system. It is implemented in multiple places with a
  class Error < StandardError; end

  module Errors
    # This exception is thrown when the credentials you have specified for the service are invalid.
    class InvalidCredentials < Error; end

    # This exception is thrown when an unknown error occurs on the server side.
    class ServerError < Error; end

    # This exception is thrown when an error happens in this process rather than on the server side.
    class ClientError < Error; end

    # A parameter you supplied as an input was not valid for the query.
    # An error class that shows the record was invalid
    class InvalidParameter < Error
      def initialize(param)
        @param = param
      end

      attr_reader :param
    end

    # A required parameter was not passed in
    class MissingParameter < Error
      def initialize(param)
        @param = param
      end

      attr_reader :param
    end

    # You attempted to fetch a page that was not valid - you probably called `next_page` on the end of the collection.
    class InvalidPage < Error; end
  end
end
