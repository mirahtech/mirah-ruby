# frozen_string_literal: true

module Mirah
  module Filters
    # A set of input parameters designed to let you select how many and which records you want from a pagination cursor.
    # It is based on Graphql's Relay specification.
    # This can be used with {Data::PageInfo}, which will be provided by the results of a server query, to provide
    # stable pagination framework.
    class Paging < BaseObject
      # @!attribute [r] first
      #   @return [string] Return the first N rows from either the start, or the current cursor position.
      #    Cannot be used at the same time as #last
      attribute :first

      # @!attribute [r] last
      #   @return [string] Return the last N rows from either the end, or the current cursor position.
      #    Cannot be used at the same time as #first
      attribute :last

      # @!attribute [r] before
      #   @return [string] Return rows before the given cursor position
      attribute :before

      # @!attribute [r] after
      #   @return [string] Return rows after the given cursor position
      attribute :after

      def self.default
        new(first: 100)
      end
    end
  end
end
