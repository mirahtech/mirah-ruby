# frozen_string_literal: true

module Mirah
  module Inputs
    # A set of parameters for updating a {Data::Appointment}
    class AppointmentInput < BaseInputObject
      # @!attribute [r] external_id
      #   @return (see Mirah::Data::Appointment#external_id)
      input :external_id, required: true

      # @!attribute [r] start_date
      #   @return (see Mirah::Data::Appointment#start_date)
      input :start_date, required: false, serializer: Serializers::DateTimeSerializer

      # @!attribute [r] end_date
      #   @return (see Mirah::Data::Appointment#end_date)
      input :end_date, required: false, serializer: Serializers::DateTimeSerializer

      # @!attribute [r] minutes_duration
      #   @return (see Mirah::Data::Appointment#minutes_duration)
      input :minutes_duration, required: false

      # @!attribute [r] status
      #   @return (see Mirah::Data::Appointment#status)
      input :status, required: true

      # @!attribute [r] external_patient_id
      #   @return (see Mirah::Data::Appointment#external_patient_id)
      input :external_patient_id, required: false

      # @!attribute [r] external_organization_id
      #   @return (see Mirah::Data::Appointment#external_organization_id)
      input :external_organization_id, required: false

      # @!attribute [r] external_practitioner_id
      #   @return (see Mirah::Data::Appointment#external_practitioner_id)
      input :external_practitioner_id, required: false
    end
  end
end
