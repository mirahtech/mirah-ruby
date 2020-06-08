# frozen_string_literal: true

module Mirah
  # Collections represent a pageable view into a given collection. They automatically let you iterate through
  # record sets in a stable manner.
  #
  # @example Iterate through a collection of multiple pages
  #   while(collection.next_page?)
  #     collection = collection.next_page
  #     collection.records.each do |record|
  #       # process record
  #     end
  #   end
  class Collection
    def initialize(results:, page_info:, client:, query:)
      @results = results
      @page_info = page_info
      @client = client
      @query = query
    end

    # The Mirah client, used for sending additional paged requests.
    attr_reader :client

    # The current results of the query
    attr_reader :results

    # The information on the current page as returned by the server
    attr_reader :page_info

    # The current set of paging parameters
    attr_reader :paging

    # The original query, stored to allow us to retrigger a query with a new page.
    attr_reader :query

    def length
      results&.length
    end

    def next_page?
      page_info.next_page?
    end

    def prev_page?
      page_info.prev_page?
    end

    def refresh_with_new_paging(paging)
      # Update everything as before, but set the new paging.
      client.query_connection(
        query[:query],
        query[:input],
        paging,
        query[:data_klass],
        query[:path]
      )
    end

    def next_page
      raise Errors::InvalidPage, 'This collection does not have a next page' unless next_page?

      return @next_page if @next_page

      @next_page = refresh_with_new_paging(next_page_params)
    end

    def prev_page
      raise Errors::InvalidPage, 'This collection does not have a previous page' unless prev_page?

      return @prev_page if @prev_page

      @prev_page = refresh_with_new_paging(prev_page_params)
    end

    private

    def next_page_params
      last = query[:paging]
      Filters::Paging.new(
        after: page_info.end_cursor,
        before: nil,
        first: last.first || last.last,
        last: nil
      )
    end

    def prev_page_params
      last = query[:paging]
      Filters::Paging.new(
        before: page_info.start_cursor,
        after: nil,
        last: last.last || last.first,
        first: nil
      )
    end
  end
end
