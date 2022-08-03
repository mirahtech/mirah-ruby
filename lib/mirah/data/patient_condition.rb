# frozen_string_literal: true

module Mirah
  module Data
    class PatientCondition < BaseObject
      # @!attribute [r] id
      #   @return [string] The internal Mirah identifier
      attribute :id

      # @!attribute [r] external_id
      #   @return [string] The identifier provided by your system
      attribute :external_id

      # @!attribute [r] status
      #   @return [string] The status of this condition
      attribute :status

      # @!attribute [r] onset_date
      #   @return [string] The date of onset
      attribute :onset_date, serializer: Serializers::DateTimeSerializer.new

      # @!attribute [r] abatement_date
      #   @return [string] The date of abatement
      attribute :abatement_date, serializer: Serializers::DateTimeSerializer.new

      # @!attribute [r] patient_id
      #   @return [string] The internal mirah id of the patient the condition applies to
      attribute :patient_id, path: %w[patient], target: 'id'

      # @!attribute [r] external_patient_id
      #   @return [string] Your system identifier for the patient the condition applies to
      attribute :external_patient_id, path: %w[patient], target: 'externalId'

      # @!attribute [r] diagnostic_code_id
      #   @return [string] The internal mirah id of the code the patient has been diagnosed with
      attribute :diagnostic_code_id, path: %w[diagnosticCode], target: 'id'

      # @!attribute [r] external_diagnostic_code_id
      #   @return [string] Your system identifier for the code the patient has been diagnosed with
      attribute :external_diagnostic_code_id, path: %w[diagnosticCode], target: 'externalId'
    end
  end
end
