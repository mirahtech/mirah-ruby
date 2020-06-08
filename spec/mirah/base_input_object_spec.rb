# frozen_string_literal: true

RSpec.describe Mirah::BaseInputObject do
  let(:test_class) do
    Class.new(Mirah::BaseInputObject) do
      input :test_string, required: true

      input :test_date, serializer: Mirah::Serializers::DateSerializer, required: false

      input :test_date_time, serializer: Mirah::Serializers::DateTimeSerializer, required: false
    end
  end

  describe '.from_graphl_hash' do
    let(:datetime) { DateTime.now }
    let(:graphql_hash) do
      {
        'testString' => 'hello',
        'testDate' => '2018-05-02',
        'testDateTime' => datetime.iso8601
      }
    end

    it 'deserializes attributes correctly' do
      expect(test_class.from_graphql_hash(graphql_hash)).to have_attributes(
        test_string: 'hello',
        test_date: Date.parse('2018-05-02'),
        test_date_time: datetime
      )
    end
  end

  describe '#initialize' do
    context 'when invalid params are passed' do
      let(:input) do
        {
          not_existing: 'blah'
        }
      end

      it 'raises an error' do
        expect { test_class.new(input) }.to raise_exception Mirah::Errors::InvalidParameter
      end
    end
  end

  describe '#valid?' do
    let(:object) { test_class.new(input) }

    context 'when all required params set' do
      let(:input) do
        {
          test_string: 'blah',
          test_date: Date.new
        }
      end

      it 'returns true' do
        expect(object).to be_valid
      end
    end

    context 'when params missing' do
      let(:input) do
        {
          test_date: Date.new
        }
      end

      it 'returns false' do
        expect(object).not_to be_valid
      end
    end
  end

  describe '#to_graphql_hash' do
    let(:object) do
      test_class.new(test_string: 'hello', test_date_time: datetime, test_date: date)
    end
    let(:date) { Date.new }
    let(:datetime) { DateTime.now }

    it 'converts to a graphql hash' do
      expect(object.to_graphql_hash).to eq(
        'testString' => 'hello',
        'testDate' => date.iso8601,
        'testDateTime' => datetime.iso8601
      )
    end
  end
end
