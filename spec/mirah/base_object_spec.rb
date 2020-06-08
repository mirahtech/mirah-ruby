# frozen_string_literal: true

RSpec.describe Mirah::BaseObject do
  let(:test_class) do
    Class.new(Mirah::BaseObject) do
      attribute :test_string

      attribute :test_date, serializer: Mirah::Serializers::DateSerializer

      attribute :test_date_time, serializer: Mirah::Serializers::DateTimeSerializer

      attribute :test_nested, path: %w[subobject], target: 'nested'

      attribute :test_nested_array, path: %w[array], target: 'value'
    end
  end

  describe '.from_graphl_hash' do
    let(:datetime) { DateTime.now }
    let(:graphql_hash) do
      {
        'testString' => 'hello',
        'testDate' => '2018-05-02',
        'testDateTime' => datetime.iso8601,
        'subobject' => {
          'nested' => 'nestedvalue'
        },
        'array' => [{ 'value' => 'a' }, { 'value' => 'b' }]
      }
    end

    it 'deserializes attributes correctly' do
      expect(test_class.from_graphql_hash(graphql_hash)).to have_attributes(
        test_string: 'hello',
        test_date: Date.parse('2018-05-02'),
        test_date_time: datetime,
        test_nested: 'nestedvalue',
        test_nested_array: %w[a b]
      )
    end
  end

  describe '#to_graphql_hash' do
    let(:object) do
      test_class.new(test_string: 'hello', test_date_time: datetime, test_date: date, test_nested: 'nestedvalue')
    end
    let(:date) { Date.new }
    let(:datetime) { DateTime.now }

    # We don't currently support writing nested arrays back to graphql as you need additional information on
    # where it came from
    it 'converts to a graphql hash' do
      expect(object.to_graphql_hash).to eq(
        'testString' => 'hello',
        'testDate' => date.iso8601,
        'testDateTime' => datetime.iso8601,
        'subobject' => {
          'nested' => 'nestedvalue'
        },
        'array' => {}
      )
    end
  end
end
