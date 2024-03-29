# frozen_string_literal: true

module Mirah
  module Graphql
    # @private
    module Mutations
      # Create or update a patient
      CreateOrUpdatePatientMutation = Graphql::ValidationClient.parse <<-'GRAPHQL'
        mutation($input: CreateOrUpdatePatientInput!) {
          createOrUpdatePatient(input: $input) {
            status
            errors {
              path
              message
            }
            result {
            ...Mirah::Graphql::Fragments::PatientFragment
            }
          }
        }
      GRAPHQL

      # Create or update an organization
      CreateOrUpdateOrganizationMutation = Graphql::ValidationClient.parse <<-'GRAPHQL'
        mutation($input: CreateOrUpdateOrganizationInput!) {
          createOrUpdateOrganization(input: $input) {
            status
            errors {
              path
              message
            }
            result {
            ...Mirah::Graphql::Fragments::OrganizationFragment
            }
          }
        }
      GRAPHQL

      # Create or update a practitioner
      CreateOrUpdatePractitionerMutation = Graphql::ValidationClient.parse <<-'GRAPHQL'
        mutation($input: CreateOrUpdatePractitionerInput!) {
          createOrUpdatePractitioner(input: $input) {
            status
            errors {
              path
              message
            }
            result {
            ...Mirah::Graphql::Fragments::PractitionerFragment
            }
          }
        }
      GRAPHQL

      # Create or update an appointment
      CreateOrUpdateAppointmentMutation = Graphql::ValidationClient.parse <<-'GRAPHQL'
        mutation($input: CreateOrUpdateAppointmentInput!) {
          createOrUpdateAppointment(input: $input) {
            status
            errors {
              path
              message
            }
            result {
            ...Mirah::Graphql::Fragments::AppointmentFragment
            }
          }
        }
      GRAPHQL

      # Create or update a diagnostic code
      CreateOrUpdateDiagnosticCodeMutation = Graphql::ValidationClient.parse <<-'GRAPHQL'
        mutation($input: CreateOrUpdateDiagnosticCodeInput!) {
          createOrUpdateDiagnosticCode(input: $input) {
            status
            errors {
              path
              message
            }
            result {
            ...Mirah::Graphql::Fragments::DiagnosticCodeFragment
            }
          }
        }
      GRAPHQL

      # Create or update a patient condition
      CreateOrUpdatePatientConditionMutation = Graphql::ValidationClient.parse <<-'GRAPHQL'
        mutation($input: CreateOrUpdatePatientConditionInput!) {
          createOrUpdatePatientCondition(input: $input) {
            status
            errors {
              path
              message
            }
            result {
            ...Mirah::Graphql::Fragments::PatientConditionFragment
            }
          }
        }
      GRAPHQL
    end
  end
end
