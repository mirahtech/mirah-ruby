# frozen_string_literal: true

module Mirah
  module Inputs
    # A set of parameters for updating a {Data::Appointment}
    class PatientConditionInput < BaseInputObject
      # @!attribute [r] external_id
      #   @return (see Mirah::Data::PatientCondition#external_id)
      input :external_id, required: true

      # @!attribute [r] onset_date
      #   @return (see Mirah::Data::PatientCondition#onset_date)
      input :onset_date, required: false, serializer: Serializers::DateTimeSerializer.new

      # @!attribute [r] abatement_date
      #   @return (see Mirah::Data::PatientCondition#abatement_date)
      input :abatement_date, required: false, serializer: Serializers::DateTimeSerializer.new

      # @!attribute [r] status
      #   @return (see Mirah::Data::PatientCondition#status)
      input :status, required: true

      # @!attribute [r] external_patient_id
      #   @return (see Mirah::Data::PatientCondition#external_patient_id)
      input :external_patient_id, required: false

      # @!attribute [r] external_diagnostic_code_id
      #   @return (see Mirah::Data::PatientCondition#external_diagnostic_code_id)
      input :external_diagnostic_code_id, required: false
    end
  end
end
