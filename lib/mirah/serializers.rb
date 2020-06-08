# frozen_string_literal: true

module Mirah
  # Graphql can automatically translate most scalars from JSON into a ruby object, but there are some which
  # cannot be done automatically, most noticably dates and times. This module provides serializers
  # that lets us do automatic serialization.
  #
  # In the future, it may also be used for the safe translation of enums. Currently, errors at this level will
  # be caught during graphql parsing.
  module Serializers
    # A standard serializer which just passes through the value as defined. This is used for basic JSON types
    # which have already been serialized correctly.
    class ScalarSerializer
      def self.serialize(value)
        value
      end

      def self.deserialize(value)
        value
      end
    end

    # Serialize types for a date in ISO 8601 format.
    class DateSerializer
      def self.serialize(value)
        Date.parse(value.to_s).iso8601 if value
      end

      def self.deserialize(value)
        Date.iso8601(value) if value
      rescue ArgumentError, TypeError
        # Invalid input
        nil
      end
    end

    # Serialize types for a date time in ISO 8601 format.
    class DateTimeSerializer
      def self.serialize(value)
        value&.iso8601
      end

      def self.deserialize(value)
        case value
        when DateTime
          value
        when Date
          DateTime.parse(value.to_s)
        when ::String
          DateTime.parse(value)
        end
      rescue StandardError
        nil
      end
    end
  end
end
