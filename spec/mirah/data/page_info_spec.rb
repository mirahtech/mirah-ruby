# frozen_string_literal: true

RSpec.describe Mirah::Data::PageInfo do
  describe '.from_graphql_hash' do
    let(:graphql) do
      {
        'endCursor' => 'abc',
        'startCursor' => 'def',
        'hasNextPage' => true,
        'hasPreviousPage' => true
      }
    end

    it 'parses from Graphql' do
      expect(described_class.from_graphql_hash(graphql)).to have_attributes(
        end_cursor: 'abc',
        start_cursor: 'def',
        has_next_page: true,
        has_previous_page: true
      )
    end
  end
end
