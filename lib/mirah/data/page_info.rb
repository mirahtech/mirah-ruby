# frozen_string_literal: true

module Mirah
  module Data
    # PageInfo gives information on the current state of paging as returned by the server. This includes information
    # about the start and the end cursors of the result set, and whether or not there are additiona pages.
    # This can be used in combination with {Mirah::Filters::Paging} to make a stable cursor-based pagination call.
    class PageInfo < BaseObject
      # @!attribute [r] end_cursor
      #   @return [string] The cursor of the last record of the current set.
      #    This can be used as a starting point for the next page of the query.
      attribute :end_cursor

      # @!attribute [r] start_cursor
      #   @return [string] The cursor of the first record of the current set.
      #    This can be used to get the previous page.
      attribute :start_cursor

      # @!attribute [r] has_next_page
      #   @return [Boolean] Whether the data set has a next page
      attribute :has_next_page

      # @!attribute [r] has_previous_page
      #   @return [Boolean] Whether the data set has a next page
      attribute :has_previous_page

      # @see has_next_page
      # @return [Boolean]
      def next_page?
        has_next_page
      end

      # @see has_previous_page
      # @return [Boolean]
      def prev_page?
        has_previous_page
      end
    end
  end
end
