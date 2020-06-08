# frozen_string_literal: true

RSpec.describe Mirah::Client do
  let(:client) do
    described_class.new(host: 'https://api.mirah.com',
                        user_id: '123', access_token: 'secret')
  end

  describe 'Error handling' do
    context 'when client unauthenticated' do
      let(:server_response) { { 'errors' => [{ 'message' => '401 Unauthorized' }] } }

      before do
        allow(client.client.execute).to receive(:execute).and_return(server_response)
      end

      it 'raises InvalidCredentials' do
        expect { client.query_patients }.to raise_exception(Mirah::Errors::InvalidCredentials)
      end
    end

    context 'when unknown error' do
      let(:server_response) { { 'errors' => [{ 'message' => 'Random error' }] } }

      before do
        allow(client.client.execute).to receive(:execute).and_return(server_response)
      end

      it 'raises InvalidCredentials' do
        expect { client.query_patients }.to raise_exception(Mirah::Errors::ServerError)
      end
    end
  end

  describe '#query_connection' do
    let(:collection) do
      client.query_connection(
        Mirah::Graphql::Queries::PatientQuery,
        Mirah::Filters::PatientFilters.new,
        Mirah::Filters::Paging.default,
        Mirah::Data::Patient,
        'patients'
      )
    end

    let(:server_response) do
      JSON.parse(File.read(File.dirname(__FILE__) + '/../fixtures/patient_query.json'))
    end

    before do
      allow(client.client.execute).to receive(:execute).and_return(server_response)
    end

    it 'returns an instantiated collection' do
      expect(collection.results.length).to eq 2
      expect(collection.next_page?).to be false
      expect(collection.prev_page?).to be false
      expect(collection.results.first).to have_attributes(
        given_name: 'James',
        family_name: 'Smith',
        birth_date: Date.parse('1991-01-01')
      )
    end
  end

  describe '#query_record' do
    let(:record) do
      client.send(:query_record,
                  Mirah::Graphql::Queries::PatientIdQuery,
                  SecureRandom.uuid,
                  Mirah::Data::Patient,
                  'patient')
    end

    let(:server_response) do
      JSON.parse(File.read(File.dirname(__FILE__) + '/../fixtures/patient_lookup.json'))
    end

    before do
      allow(client.client.execute).to receive(:execute).and_return(server_response)
    end

    it 'returns an instantiated model' do
      expect(record).to have_attributes(
        given_name: 'James',
        family_name: 'Smith',
        birth_date: Date.parse('1991-01-01')
      )
    end
  end

  describe '#query_record_by_external_id' do
    let(:record) do
      client.send(:query_record,
                  Mirah::Graphql::Queries::PatientExternalIdQuery,
                  SecureRandom.uuid,
                  Mirah::Data::Patient,
                  'patient')
    end

    let(:server_response) do
      JSON.parse(File.read(File.dirname(__FILE__) + '/../fixtures/patient_lookup.json'))
    end

    before do
      allow(client.client.execute).to receive(:execute).and_return(server_response)
    end

    it 'returns an instantiated model' do
      expect(record).to have_attributes(
        given_name: 'James',
        family_name: 'Smith',
        birth_date: Date.parse('1991-01-01')
      )
    end
  end

  # PATIENTS METHODS
  describe '.query_patients' do
    it 'returns successfully' do
      VCR.use_cassette('patients') do
        collection = authorized_client.query_patients
        expect(collection.length).to be > 0
        expect(collection.results.map(&:given_name)).to match_array(%w[Andrew Brian Charlotte])
      end
    end

    it 'returns successfully with parameters' do
      VCR.use_cassette('patients') do
        collection = authorized_client.query_patients(search: 'Andrew', external_id: ['aa'])
        expect(collection.length).to eq 1
        expect(collection.results.map(&:given_name)).to match_array(%w[Andrew])
      end
    end
  end

  describe '.find_patients' do
    it 'finds patients successfully' do
      VCR.use_cassette('patients') do
        external_find = authorized_client.find_patient_by_external_id('aa')
        result = authorized_client.find_patient(external_find.id)
        expect(result.given_name).to eq 'Andrew'
      end
    end
  end

  describe '.push_patient' do
    let(:params) do
      {
        given_name: 'Tim',
        family_name: 'Thomas',
        birth_date: Date.parse('2000-01-01'),
        email: 'tim@mirah.com',
        phone_number: '555-555-5555',
        gender: 'MALE'
      }
    end

    it 'creates patients successfully' do
      VCR.use_cassette('patients') do
        result = authorized_client.push_patient(external_id: 'tt', **params)

        expect(result).to have_attributes(
          status: 'CREATED',
          result: have_attributes(params)
        )
      end
    end
  end

  # ORGANIZATION METHODS
  describe '.query_organizations' do
    it 'returns successfully' do
      VCR.use_cassette('organizations') do
        collection = authorized_client.query_organizations
        expect(collection.length).to be > 0
        expect(collection.results.map(&:name)).to match_array(['Test Hospital', 'Acute Unit'])
      end
    end

    it 'returns successfully with parameters' do
      VCR.use_cassette('organizations') do
        collection = authorized_client.query_organizations(search: 'Test Hospital', external_id: ['hospital'])
        expect(collection.length).to eq 1
        expect(collection.results.map(&:name)).to match_array(['Test Hospital'])
      end
    end
  end

  describe '.find_organizations' do
    it 'finds organizations successfully' do
      VCR.use_cassette('organizations') do
        external_find = authorized_client.find_organization_by_external_id('hospital')
        result = authorized_client.find_organization(external_find.id)
        expect(result.name).to eq 'Test Hospital'
      end
    end
  end

  describe '.push_organization' do
    let(:params) do
      {
        name: 'Outpatient Therapy',
        external_part_of_id: 'hospital'
      }
    end

    it 'creates organizations successfully' do
      VCR.use_cassette('organizations') do
        result = authorized_client.push_organization(external_id: 'outpatient', **params)

        expect(result).to have_attributes(
          status: 'CREATED',
          result: have_attributes({
                                    name: 'Outpatient Therapy',
                                    part_of_id: be_an_instance_of(String),
                                    external_part_of_id: 'hospital'
                                  })
        )
      end
    end
  end

  # PRACTITIONER METHODS
  describe '.query_practitioners' do
    it 'returns successfully' do
      VCR.use_cassette('practitioners') do
        collection = authorized_client.query_practitioners
        expect(collection.length).to be > 0
        expect(collection.results.map(&:given_name)).to match_array(%w[Greg Dana])
      end
    end

    it 'returns successfully with parameters' do
      VCR.use_cassette('practitioners') do
        collection = authorized_client.query_practitioners(search: 'Greg', external_id: ['house'])
        expect(collection.length).to eq 1
        expect(collection.results.map(&:given_name)).to match_array(['Greg'])
      end
    end
  end

  describe '.find_practitioners' do
    it 'finds practitioners successfully' do
      VCR.use_cassette('practitioners') do
        external_find = authorized_client.find_practitioner_by_external_id('house')
        result = authorized_client.find_practitioner(external_find.id)
        expect(result.given_name).to eq 'Greg'
      end
    end
  end

  describe '.push_practitioner' do
    let(:params) do
      {
        given_name: 'John',
        family_name: 'Zoiberg',
        title: 'Dr',
        suffix: 'MD',
        email: 'zoidberg@mirah.com',
        default_practitioner_role: 'CLINICIAN',
        sso_username: 'drzoidberg',
        external_organization_ids: ['hospital']
      }
    end

    it 'creates practitioners successfully' do
      VCR.use_cassette('practitioners') do
        result = authorized_client.push_practitioner(external_id: 'drzoidberg', **params)

        expect(result).to have_attributes(
          status: 'CREATED',
          result: have_attributes(params)
        )
      end
    end
  end

  # APPOINTMENT METHODS
  describe '.query_appointments' do
    it 'returns successfully' do
      VCR.use_cassette('appointments') do
        collection = authorized_client.query_appointments
        expect(collection.length).to be > 0
        expect(collection.results.map(&:external_id)).to match_array(%w[appt1 appt2])
      end
    end

    it 'returns successfully with parameters' do
      VCR.use_cassette('appointments') do
        collection = authorized_client.query_appointments(external_id: ['appt1'], status: ['FULFILLED'])
        expect(collection.length).to eq 1
        expect(collection.results.map(&:external_id)).to match_array(['appt1'])
      end
    end
  end

  describe '.find_appointments' do
    it 'finds appointments successfully' do
      VCR.use_cassette('appointments') do
        external_find = authorized_client.find_appointment_by_external_id('appt1')
        result = authorized_client.find_appointment(external_find.id)
        expect(result.external_id).to eq 'appt1'
      end
    end
  end

  describe '.push_appointment' do
    let(:params) do
      {
        start_date: DateTime.parse('2020-06-10T17:00:00Z'),
        end_date: DateTime.parse('2020-06-10T18:00:00Z'),
        minutes_duration: 60,
        status: 'BOOKED',
        external_patient_id: 'cc',
        external_practitioner_id: 'scully',
        external_organization_id: 'hospital'
      }
    end

    it 'creates appointments successfully' do
      VCR.use_cassette('appointments') do
        result = authorized_client.push_appointment(external_id: 'appt99', **params)

        expect(result).to have_attributes(
          status: 'CREATED',
          result: have_attributes(params)
        )
      end
    end
  end
end
