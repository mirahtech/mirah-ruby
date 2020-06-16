# frozen_string_literal: true

module Mirah
  module Data
    # Appointments represent a planned or past meeting between a patient and a practitioner. This is based
    # on https://www.hl7.org/fhir/appointment.html
    # As part of the integration flow, Mirah will work out whether this appointments needs an accompanying measurement
    # encounter and automatically create one as appropriate. Mirah's ETL will generally make a best effort to estimate
    # where and what context the measurement should be taken. The more information (Episode of Care, Organization,
    # etc) that you supply, the more likely it is to be correct.
    # Note that as part of this processing, Mirah may immediately choose to create assessments and trigger
    # communications with the patient or other participants, for example by text message or email.
    # In order to keep adherence statistics up to date, Mirah also requires that updates on past
    # appointments are sent, so that we can calculate whether e.g. the appointment was a no-show.
    class Appointment < BaseObject
      # @!attribute [r] id
      #   @return [string] The internal Mirah identifier
      attribute :id

      # @!attribute [r] external_id
      #   @return [string] The identifier provided by your system
      attribute :external_id

      # @!attribute [r] start_date
      #   @return [Date] The appointment start date
      attribute :start_date, serializer: Serializers::DateTimeSerializer.new

      # @!attribute [r] end_date
      #   @return [Date] The appointment end date
      attribute :end_date, serializer: Serializers::DateTimeSerializer.new

      # @!attribute [r] minutes_duration
      #   @return [Integer] The legnth of this appointment in minutes
      attribute :minutes_duration

      # @!attribute [r] status
      #   @return [string] The appointment status
      attribute :status

      # @!attribute [r] patient_id
      #   @return [string] The internal mirah id of the patient
      attribute :patient_id, path: %w[patient], target: 'id'

      # @!attribute [r] external_patient_id
      #   @return [string] Your system identifier for the patient
      attribute :external_patient_id, path: %w[patient], target: 'externalId'

      # @!attribute [r] practitioner_id
      #   @return [string] The internal mirah id of the practitioner this appointment is with
      attribute :practitioner_id, path: %w[practitioner], target: 'id'

      # @!attribute [r] external_practitioner_id
      #   @return [string] Your system identifier for the practitioner this appointment is with
      attribute :external_practitioner_id, path: %w[practitioner], target: 'externalId'

      # @!attribute [r] organization_id
      #   @return [string] The internal mirah id of the organization this appointment is with
      attribute :organization_id, path: %w[organization], target: 'id'

      # @!attribute [r] external_organization_id
      #   @return [string] Your system identifier for the organization this appointment is with
      attribute :external_organization_id, path: %w[organization], target: 'externalId'

      # @!attribute [r] encounter_id
      #   @return [string] The internal mirah id of the patient
      attribute :encounter_id, path: %w[measurementEncounter], target: 'id'

      # @!attribute [r] invitations
      #   @return [Array<Invitation>] An array of invitations for measurements associated with this appointment.
      attribute :invitations, path: %w[measurementEncounter], target: 'measurementInvitations',
                              serializer: Serializers::NestedObjectSerializer.new(Invitation)

      # Whether this appointment has a Mirah measurement encounter associated with it.
      def measured?
        !!encounter_id
      end
    end
  end
end
