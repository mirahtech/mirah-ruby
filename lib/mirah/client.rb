# frozen_string_literal: true

module Mirah
  # A client designed to communicate with the Mirah system in a constrained set of well defined ways.
  # This is a front to the more general Graphql backend which is available.
  #
  # == Patient Methods
  # * {find_patient}
  # * {find_patient_by_external_id}
  # * {query_patients}
  # * {push_patient}
  #
  # == Organization Methods
  # * {find_organization}
  # * {find_organization_by_external_id}
  # * {query_organizations}
  # * {push_organization}
  #
  # == Practitioner Methods
  # * {find_practitioner}
  # * {find_practitioner_by_external_id}
  # * {query_practitioners}
  # * {push_practitioner}
  #
  # == Appointment Methods
  # * {find_appointment}
  # * {find_appointment_by_external_id}
  # * {query_appointments}
  # * {push_appointment}
  #
  # @example
  #   # Create a new client
  #   client = Mirah::Client.new(host: 'https://api.mirah.com', user_id: 'my_user_id', access_token: 'my_token')
  #
  #   # find a patient
  #   client.find_patient_by_external_id('mrn0001')
  class Client # rubocop:disable Metrics/ClassLength
    # Construct a new Client with the given host and credentials.
    # @param host [String] The host, e.g. 'https://api.mirah.com'
    # @param user_id [String] Your user id
    # @param access_token [String] Your secret API token.
    def initialize(host:, user_id:, access_token:)
      @client = Graphql.create_client(host: host)
      @client_context = { user_id: user_id, access_token: access_token }
    end

    # Access to the underlying graphql client. You may use this for advanced queries that are not provided
    # as part of the standard library.
    attr_reader :client

    #################################################################################################################
    # PATIENT METHODS
    #################################################################################################################

    # Find a patient by the given Mirah internal UUID. This method should be used if you already know the Mirah
    # identifier. If you wish to query by your own system identifier, you should use {#find_patient_by_external_id}
    #
    # @since 0.1.0
    # @param id [String] Mirah UUID for the patient
    # @return [Data::Patient, nil] the patient, or nil if the record does not exist.
    def find_patient(id)
      query_record(Graphql::Queries::PatientIdQuery, id, Data::Patient, 'patient')
    end

    # Find a patient by your external id. This is a convenience method. If you wish to query a list of patients
    # by external id, please use {Client#query_patients}.
    #
    # @since 0.1.0
    # @param external_id [String] The identifier of the system of record
    # @return [Data::Patient, nil] the patient, or nil if the record does not exist.
    def find_patient_by_external_id(external_id)
      query_record_by_external_id(Graphql::Queries::PatientExternalIdQuery,
                                  external_id,
                                  Data::Patient,
                                  'patientExternal')
    end

    # Query for patients. You may specify a set of parameters as defined in {Mirah::Filters::PatientFilters}.
    # Results are returned in a paginated format. See {Collection} for how to page results.
    #
    # @since 0.1.0
    # @param external_id [Array<String>] See {Mirah::Filters::PatientFilters#external_id}
    # @param search [String] See {Mirah::Filters::PatientFilters#search}
    # @return [Collection<Data::Patient>] a collection of pageable patients.
    def query_patients(external_id: nil, search: nil)
      query_connection(
        Graphql::Queries::PatientQuery,
        Filters::PatientFilters.new(external_id: external_id, search: search),
        Filters::Paging.default,
        Data::Patient,
        'patients'
      )
    end

    # Create or update a patient. You must specify an external identifier, all other parameters are optional,
    # but you may receive errors if you attempt to specify too few parameters for a patient that does not exist.
    #
    # @since 0.1.0
    # @param external_id [String] the external identifier for this patient
    # @option input_values [String, nil] :given_name see {Data::Patient#given_name}
    # @option input_values [String, nil] :family_name see {Data::Patient#family_name}
    # @option input_values [Date, nil] :birth_date see {Data::Patient#birth_date}
    # @option input_values [String, nil] :gender see {Data::Patient#gender}
    # @option input_values [String, nil] :primary_language see {Data::Patient#primary_language}
    # @option input_values [String, nil] :email see {Data::Patient#email}
    # @option input_values [String, nil] :phone_number see {Data::Patient#phone_number}
    # @option input_values [String, nil] :external_managing_organization_id
    #                                     see {Data::Patient#external_managing_organization_id}
    # @return [PushResult<Data::Patient>] the operation result with a patient on success
    def push_patient(external_id:, **input_values)
      mutate(Graphql::Mutations::CreateOrUpdatePatientMutation,
             Inputs::PatientInput.new(input_values.merge(external_id: external_id)),
             Data::Patient, 'createOrUpdatePatient')
    end

    #################################################################################################################
    # ORGANIZATION METHODS
    #################################################################################################################

    # Find an organization by the given Mirah internal UUID. This method should be used if you already know the Mirah
    # identifier. If you wish to query by your own system identifier, you should use {#find_organization_by_external_id}
    #
    # @since 0.1.0
    # @param id [String] Mirah UUID for the organization
    # @return [Data::Organization, nil] the organization, or nil if the record does not exist.
    def find_organization(id)
      query_record(Graphql::Queries::OrganizationIdQuery, id, Data::Organization, 'organization')
    end

    # Find an organization by your external id. This is a convenience method. If you wish to query a list of
    # organizations by external id, please use {Client#query_organizations}.
    #
    # @since 0.1.0
    # @param external_id [String] The identifier of the system of record
    # @return [Data::Organization, nil] the organization, or nil if the record does not exist.
    def find_organization_by_external_id(external_id)
      query_record_by_external_id(Graphql::Queries::OrganizationExternalIdQuery,
                                  external_id,
                                  Data::Organization,
                                  'organizationExternal')
    end

    # Query for organizations. You may specify a set of parameters as defined in {Mirah::Filters::OrganizationFilters}.
    # Results are returned in a paginated format. See {Collection} for how to page results.

    # @since 0.1.0
    # @param external_id [Array<String>] See {Mirah::Filters::OrganizationFilters#external_id}
    # @param search [String] See {Mirah::Filters::OrganizationFilters#search}
    # @return [Collection<Data::Organization>] a collection of pageable organizations.
    def query_organizations(external_id: nil, search: nil)
      query_connection(
        Graphql::Queries::OrganizationQuery,
        Filters::OrganizationFilters.new(external_id: external_id, search: search),
        Filters::Paging.default,
        Data::Organization,
        'organizations'
      )
    end

    # Create or update an organization. You must specify an external identifier, all other parameters are optional,
    # but you may receive errors if you attempt to specify too few parameters for an organization that does not exist.
    #
    # @since 0.1.0
    # @param external_id [String] the external identifier for this organization
    # @option input_values [String, nil] :name see {Data::Organization#name}
    # @option input_values [String, nil] :external_part_of_id The external identifier for the parent organization
    # @return [PushResult<Data::Organization>] the operation result with the organization on success
    def push_organization(external_id:, **input_values)
      mutate(Graphql::Mutations::CreateOrUpdateOrganizationMutation,
             Inputs::OrganizationInput.new(input_values.merge(external_id: external_id)),
             Data::Organization, 'createOrUpdateOrganization')
    end

    #################################################################################################################
    # PRACTITIONER METHODS
    #################################################################################################################

    # Find an practitioner by the given Mirah internal UUID. This method should be used if you already know the Mirah
    # identifier. If you wish to query by your own system identifier, you should use {#find_practitioner_by_external_id}
    #
    # @since 0.1.0
    # @param id [String] Mirah UUID for the practitioner
    # @return [Data::Practitioner, nil] the practitioner, or nil if the record does not exist.
    def find_practitioner(id)
      query_record(Graphql::Queries::PractitionerIdQuery, id, Data::Practitioner, 'practitioner')
    end

    # Find an practitioner by your external id. This is a convenience method. If you wish to query a list of
    # practitioners by external id, please use {Client#query_practitioners}.
    #
    # @since 0.1.0
    # @param external_id [String] The identifier of the system of record
    # @return [Data::Practitioner, nil] the practitioner, or nil if the record does not exist.
    def find_practitioner_by_external_id(external_id)
      query_record_by_external_id(Graphql::Queries::PractitionerExternalIdQuery,
                                  external_id,
                                  Data::Practitioner,
                                  'practitionerExternal')
    end

    # Query for practitioners. You may specify a set of parameters as defined in {Mirah::Filters::PractitionerFilters}.
    # Results are returned in a paginated format. See {Collection} for how to page results.
    #
    # @since 0.1.0
    # @param external_id [String] See {Mirah::Filters::PractitionerFilters#external_id}
    # @param search [String] See {Mirah::Filters::PractitionerFilters#search}
    # @return [Collection<Data::Practitioner>] a collection of pageable practitioners.
    def query_practitioners(external_id: nil, search: nil)
      query_connection(
        Graphql::Queries::PractitionerQuery,
        Filters::PractitionerFilters.new(external_id: external_id, search: search),
        Filters::Paging.default,
        Data::Practitioner,
        'practitioners'
      )
    end

    # Create or update an practitioner. You must specify an external identifier, all other parameters are optional,
    # but you may receive errors if you attempt to specify too few parameters for an practitioner that does not exist.
    #
    # @since 0.1.0
    # @param external_id [String] the external identifier for this practitioner
    # @option input_values [String, nil] :given_name see {Data::Practitioner#given_name}
    # @option input_values [String, nil] :family_name see {Data::Practitioner#family_name}
    # @option input_values [String, nil] :title see {Data::Practitioner#title}
    # @option input_values [String, nil] :suffix see {Data::Practitioner#suffix}
    # @option input_values [String, nil] :email see {Data::Practitioner#email}
    # @option input_values [String, nil] :default_practitioner_role see {Data::Practitioner#default_practitioner_role}
    # @option input_values [String, nil] :sso_username see {Data::Practitioner#sso_username}
    # @option input_values [Array<String>, nil] :external_organization_ids see
    #                                           {Data::Practitioner#external_organization_ids}
    # @return [PushResult<Data::Practitioner>] the operation result with the practitioner on success
    def push_practitioner(external_id:, **input_values)
      mutate(Graphql::Mutations::CreateOrUpdatePractitionerMutation,
             Inputs::PractitionerInput.new(input_values.merge(external_id: external_id)),
             Data::Practitioner, 'createOrUpdatePractitioner')
    end

    #################################################################################################################
    # APPOINTMENT METHODS
    #################################################################################################################

    # Find an appointment by the given Mirah internal UUID. This method should be used if you already know the Mirah
    # identifier. If you wish to query by your own system identifier, you should use {#find_appointment_by_external_id}
    #
    # @since 0.1.0
    # @param id [String] Mirah UUID for the appointment
    # @return [Data::Appointment, nil] the appointment, or nil if the record does not exist.
    def find_appointment(id)
      query_record(Graphql::Queries::AppointmentIdQuery, id, Data::Appointment, 'appointment')
    end

    # Find an appointment by your external id. This is a convenience method. If you wish to query a list of
    # appointments by external id, please use {Client#query_appointments}.
    #
    # @since 0.1.0
    # @param external_id [String] The identifier of the system of record
    # @return [Data::Appointment, nil] the appointment, or nil if the record does not exist.
    def find_appointment_by_external_id(external_id)
      query_record_by_external_id(Graphql::Queries::AppointmentExternalIdQuery,
                                  external_id,
                                  Data::Appointment,
                                  'appointmentExternal')
    end

    # Query for appointments. You may specify a set of parameters as defined in {Mirah::Filters::AppointmentFilters}.
    # Results are returned in a paginated format. See {Collection} for how to page results.

    # @since 0.1.0
    # @param external_id [Array<String>] See {Mirah::Filters::AppointmentFilters#external_id}
    # @param status [String] See {Mirah::Filters::AppointmentFilters#external_id}
    # @return [Collection<Data::Appointment>] a collection of pageable appointments.
    def query_appointments(external_id: nil, status: nil)
      query_connection(
        Graphql::Queries::AppointmentQuery,
        Filters::AppointmentFilters.new(external_id: external_id, status: status),
        Filters::Paging.default,
        Data::Appointment,
        'appointments'
      )
    end

    # Create or update an appointment. You must specify an external identifier, all other parameters are optional,
    # but you may receive errors if you attempt to specify too few parameters for an appointment that does not exist.
    #
    # @since 0.1.0
    # @param external_id [String] the external identifier for this appointment
    # @param status [String] the status identifier of this appointment, see {Data::Appointment#status}
    # @option input_values [String, nil] :start_date see {Data::Appointment#start_date}
    # @option input_values [String, nil] :end_date see {Data::Appointment#end_date}
    # @option input_values [String, nil] :minutes_duration see {Data::Appointment#minutes_duration}
    # @option input_values [String, nil] :patient_id see {Data::Appointment#patient_id}
    # @option input_values [String, nil] :external_patient_id see {Data::Appointment#external_patient_id}
    # @option input_values [String, nil] :practitioner_id see {Data::Appointment#practitioner_id}
    # @option input_values [String, nil] :external_practitioner_id see {Data::Appointment#external_practitioner_id}
    # @option input_values [String, nil] :organization_id see {Data::Appointment#organization_id}
    # @option input_values [String, nil] :external_organization_id see {Data::Appointment#external_organization_id}
    # @return [PushResult<Data::Appointment>] the operation result with the appointment on success
    def push_appointment(external_id:, status:, **input_values)
      mutate(Graphql::Mutations::CreateOrUpdateAppointmentMutation,
             Inputs::AppointmentInput.new(input_values.merge(external_id: external_id, status: status)),
             Data::Appointment, 'createOrUpdateAppointment')
    end

    #################################################################################################################
    # DIAGNOSTIC CODE METHODS
    #################################################################################################################

    # Find an diagnostic code by the given Mirah internal UUID. This method should be used if you already know the Mirah
    # identifier. If you wish to query by your own system identifier, you should use
    # {#find_diagnostic_code_by_external_id}
    #
    # @since 0.4.0
    # @param id [String] Mirah UUID for the diagnostic code
    # @return [Data::DiagnosticCode, nil] the code, or nil if the record does not exist.
    def find_diagnostic_code(id)
      query_record(Graphql::Queries::DiagnosticCodeIdQuery, id, Data::DiagnosticCode, 'diagnosticCode')
    end

    # Find a diagnostic code by your external id. This is a convenience method. If you wish to query a list of
    # codes by external id, please use {Client#query_diagnostic_codes}.
    #
    # @since 0.4.0
    # @param external_id [String] The identifier of the system of record
    # @return [Data::DiagnosticCode, nil] the code, or nil if the record does not exist.
    def find_diagnostic_code_by_external_id(external_id)
      query_record_by_external_id(Graphql::Queries::DiagnosticCodeExternalIdQuery,
                                  external_id,
                                  Data::DiagnosticCode,
                                  'diagnosticCodeExternal')
    end

    # Query for diagnostic codes. You may specify a set of parameters as defined in
    # {Mirah::Filters::DiagnosticCodeFilters}.
    # Results are returned in a paginated format. See {Collection} for how to page results.
    # @since 0.4.0
    # @param external_id [Array<String>] See {Mirah::Filters::DiagnosticCodeFilters#external_id}
    # @param search [Array<String>] See {Mirah::Filters::DiagnosticCodeFilters#search}
    # @return [Collection<Data::Appointment>] a collection of pageable codes.
    def query_diagnostic_codes(external_id: nil, search: nil)
      query_connection(
        Graphql::Queries::DiagnosticCodeQuery,
        Filters::DiagnosticCodeFilters.new(external_id: external_id, search: search),
        Filters::Paging.default,
        Data::DiagnosticCode,
        'diagnosticCodes'
      )
    end

    # Create or update a diagnosis code. You must specify an external identifier, all other parameters are optional,
    # but you may receive errors if you attempt to specify too few parameters for an appointment that does not exist.
    #
    # @since 0.1.0
    # @param external_id [String] the external identifier for this code
    # @option input_values [String, nil] :name see {Data::DiagnosticCode#name}
    # @option input_values [String, nil] :code see {Data::DiagnosticCode#code}
    # @return [PushResult<Data::DiagnosticCode>] the operation result with the code on success
    def push_diagnostic_code(external_id:, **input_values)
      mutate(Graphql::Mutations::CreateOrUpdateDiagnosticCodeMutation,
             Inputs::DiagnosticCodeInput.new(input_values.merge(external_id: external_id)),
             Data::DiagnosticCode, 'createOrUpdateDiagnosticCode')
    end

    #################################################################################################################
    # PATIENT CONDITION METHODS
    #################################################################################################################

    # Find an condition by the given Mirah internal UUID. This method should be used if you already know the Mirah
    # identifier. If you wish to query by your own system identifier, you should use
    # {#find_patient_condition_by_external_id}
    #
    # @since 0.4.0
    # @param id [String] Mirah UUID for the condition
    # @return [Data::PatientCondition, nil] the code, or nil if the record does not exist.
    def find_patient_condition(id)
      query_record(Graphql::Queries::PatientConditionIdQuery, id, Data::PatientCondition, 'patientCondition')
    end

    # Find a condition by your external id. This is a convenience method. If you wish to query a list of
    # codes by external id, please use {Client#query_patient_conditions}.
    #
    # @since 0.4.0
    # @param external_id [String] The identifier of the system of record
    # @return [Data::PatientCondition, nil] the code, or nil if the record does not exist.
    def find_patient_condition_by_external_id(external_id)
      query_record_by_external_id(Graphql::Queries::PatientConditionExternalIdQuery,
                                  external_id,
                                  Data::PatientCondition,
                                  'patientConditionExternal')
    end

    # Query for conditions. You may specify a set of parameters as defined in
    # {Mirah::Filters::PatientConditionFilters}.
    # Results are returned in a paginated format. See {Collection} for how to page results.
    # @since 0.4.0
    # @param external_id [Array<String>] See {Mirah::Filters::PatientConditionFilters#external_id}
    # @return [Collection<Data::Appointment>] a collection of pageable codes.
    def query_patient_conditions(external_id: nil)
      query_connection(
        Graphql::Queries::PatientConditionQuery,
        Filters::PatientConditionFilters.new(external_id: external_id),
        Filters::Paging.default,
        Data::PatientCondition,
        'patientConditions'
      )
    end

    # Create or update a condition. You must specify an external identifier, all other parameters are optional,
    # but you may receive errors if you attempt to specify too few parameters for an appointment that does not exist.
    #
    # @since 0.1.0
    # @param external_id [String] the external identifier for this code
    # @option input_values [String, nil] :name see {Data::PatientCondition#name}
    # @option input_values [String, nil] :code see {Data::PatientCondition#code}
    # @return [PushResult<Data::PatientCondition>] the operation result with the code on success
    def push_patient_condition(external_id:, **input_values)
      mutate(Graphql::Mutations::CreateOrUpdatePatientConditionMutation,
             Inputs::PatientConditionInput.new(input_values.merge(external_id: external_id)),
             Data::PatientCondition, 'createOrUpdatePatientCondition')
    end

    ##################################################################################################################
    # Internal methods
    ##################################################################################################################

    # This is technically a public method so that collections can get the next page, but should not generally
    # be invoked directly otherwise.
    # @private
    def query_connection(query, input, paging, data_klass, path)
      variables = input.to_graphql_hash.merge(paging.to_graphql_hash)
      response = client.query(query, variables: variables, context: client_context)
      check_response_for_errors(response)

      response_json = response.to_h
      results = parse_graphql_connection_response(response_json, data_klass, path, 'nodes')
      page_info = parse_page_info(response_json, path)

      # Used to generate subsequent pages
      query_details = { query: query, input: input, paging: paging, data_klass: data_klass, path: path }
      Collection.new(results: results, page_info: page_info, client: self, query: query_details)
    rescue StandardError => e
      handle_errors(e)
    end

    private

    attr_reader :client_context

    def query_record(query, id, data_klass, path)
      response = client.query(query, variables: { id: id }, context: client_context)
      check_response_for_errors(response)
      response_json = response.to_h

      parse_graphql_response(response_json, data_klass, path)
    rescue StandardError => e
      handle_errors(e)
    end

    def query_record_by_external_id(query, external_id, data_klass, path)
      response = client.query(query, variables: { externalId: external_id }, context: client_context)
      check_response_for_errors(response)
      response_json = response.to_h

      parse_graphql_response(response_json, data_klass, path)
    rescue StandardError => e
      handle_errors(e)
    end

    def mutate(mutation, input, data_klass, path)
      input.validate!
      response = client.query(mutation, variables: { input: input.to_graphql_hash }, context: client_context)

      response_json = response.to_h.dig('data', path)

      if response_json
        result = data_klass.from_graphql_hash(response_json['result']) if response_json['result']

        status = response_json['status']
        errors = response_json['errors']
      else
        status = 'ERROR'
        errors = response.to_h['errors']
      end

      PushResult.new(result: result, status: status, errors: errors, input: input)
    rescue StandardError => e
      handle_errors(e)
    end

    # Parse the main part of the graphql response into the appropriate data class.
    #
    # @param response_json [GraphQL::Client::Response] the graphql error response
    # @param data_klass [Class] the class to transform the response into
    # @param path [String] the path in the response to look for the raw data
    # @return [Class] an item of the type of `data_klass`
    def parse_graphql_response(response_json, data_klass, path)
      data_klass.from_graphql_hash(response_json.dig('data', path))
    end

    def parse_page_info(response_json, path)
      Data::PageInfo.from_graphql_hash(response_json.dig('data', path, 'pageInfo'))
    end

    # Parse the main part of the graphql response into the appropriate data class with additional paging
    # and connection information.
    #
    # @param response_json [GraphQL::Client::Response] the graphql error response
    # @param data_klass [Class] the class to transform the response into
    # @param path [String] the path in the response to look for the raw data
    # @return [Collection<Class>] a wrapped collection with the results
    def parse_graphql_connection_response(response_json, data_klass, path, item = 'nodes')
      response_json.dig('data', path, item)&.map do |datum|
        data_klass.from_graphql_hash(datum.to_h)
      end
    end

    # Check that any errors raised have been wrapped in Mirah errors appropriately.
    def handle_errors(e)
      case e
      when Error
        raise
      else
        raise Errors::ClientError, e
      end
    end

    def check_response_for_errors(response)
      if response.errors.any?
        if response.errors[:data] == ['401 Unauthorized'] # rubocop:disable Style/GuardClause
          raise Errors::InvalidCredentials, 'The credentials you have supplied are invalid'
        else
          raise Errors::ServerError, "Unknown error from Mirah server: #{response.errors.values.flatten.join(',')}"
        end
      end

      raise Errors::ServerError, 'Data payload was empty' unless response.data
    end
  end
end
