# frozen_string_literal: true

RSpec.describe Mirah::Collection do
  let(:results) { %w[example1 example2] }
  let(:page_info) { Mirah::Data::PageInfo.new }
  let(:paging) { Mirah::Filters::Paging.new(first: 10) }
  let(:query) do
    {
      query: Mirah::Graphql::Queries::PatientQuery,
      input: Mirah::Filters::PatientFilters.new,
      paging: paging,
      data_klass: Mirah::Data::Patient,
      path: 'patients'
    }
  end

  let(:client) { Mirah::Client.new(host: 'api.mirah.com', user_id: 'my_user_id', access_token: 'secret') }

  let(:collection) do
    described_class.new(results: results, page_info: page_info, query: query, client: client)
  end

  describe '#next_page' do
    context 'when there is no next page' do
      let(:page_info) { Mirah::Data::PageInfo.new(has_next_page: false) }

      it 'raises an error' do
        expect { collection.next_page }.to raise_exception(Mirah::Errors::InvalidPage)
      end
    end

    context 'when there is a next page' do
      let(:page_info) { Mirah::Data::PageInfo.new(has_next_page: true, end_cursor: 'abc') }
      let(:page_double) { instance_double('Collection') }

      it 'shows the next page' do
        expect(client).to receive(:query_connection).once.with(
          query[:query],
          query[:input],
          having_attributes(first: 10, after: 'abc', last: nil, before: nil),
          query[:data_klass],
          query[:path]
        ).and_return(page_double)

        expect(collection.next_page).to eq(page_double)
      end

      it 'caches the next page' do
        expect(client).to receive(:query_connection).once.and_return(page_double)
        expect(collection.next_page).to eq(page_double)
        expect(collection.next_page).to eq(page_double)
      end
    end
  end

  describe '#prev_page' do
    context 'when there is no next page' do
      let(:page_info) { Mirah::Data::PageInfo.new(has_previous_page: false) }

      it 'raises an error' do
        expect { collection.next_page }.to raise_exception(Mirah::Errors::InvalidPage)
      end
    end

    context 'when there is a previous page' do
      let(:page_info) { Mirah::Data::PageInfo.new(has_previous_page: true, start_cursor: 'abc') }
      let(:page_double) { instance_double('Collection') }

      it 'shows the next page' do
        expect(client).to receive(:query_connection).once.with(
          query[:query],
          query[:input],
          having_attributes(first: nil, last: 10, before: 'abc', after: nil),
          query[:data_klass],
          query[:path]
        ).and_return(page_double)

        expect(collection.prev_page).to eq(page_double)
      end

      it 'caches the previous page' do
        expect(client).to receive(:query_connection).once.and_return(page_double)
        expect(collection.prev_page).to eq(page_double)
        expect(collection.prev_page).to eq(page_double)
      end
    end
  end
end
