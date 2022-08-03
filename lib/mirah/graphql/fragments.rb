# frozen_string_literal: true

module Mirah
  module Graphql
    # @private
    module Fragments
      PageInfoFragment = Graphql::ValidationClient.parse <<-'GRAPHQL'
        fragment on PageInfo {
            hasNextPage
            hasPreviousPage
            startCursor
            endCursor
          }
      GRAPHQL

      PatientFragment = Graphql::ValidationClient.parse <<-'GRAPHQL'
        fragment on Patient {
          id
          externalId
          givenName
          familyName
          birthDate
          gender
          primaryLanguage
          email
          phoneNumber
          timezone
          managingOrganization {
            id
            externalId
          }
          identifier {
            value
          }
        }
      GRAPHQL

      OrganizationFragment = Graphql::ValidationClient.parse <<-'GRAPHQL'
        fragment on Organization {
          id
          externalId
          name
          identifier {
            value
          }
          partOf {
            id
            externalId
          }
        }
      GRAPHQL

      PractitionerFragment = Graphql::ValidationClient.parse <<-'GRAPHQL'
        fragment on Practitioner {
          id
          externalId
          givenName
          familyName
          title
          suffix
          email
          defaultPractitionerRole
          ssoUsername
          identifier {
            value
          }
          organizations {
            id
            externalId
          }
        }
      GRAPHQL

      AppointmentFragment = Graphql::ValidationClient.parse <<-'GRAPHQL'
        fragment on Appointment {
          id
          externalId
          startDate
          endDate
          minutesDuration
          status
          patient {
            id
            externalId
          }
          organization {
            id
            externalId
          }
          organization {
            id
            externalId
          }
          practitioner {
            id
            externalId
          }
          measurementEncounter {
            id
            measurementInvitations {
              id
              phase
              status
              notificationStatus
              lastNotificationDate
            }
          }
        }
      GRAPHQL

      DiagnosticCodeFragment = Graphql::ValidationClient.parse <<-'GRAPHQL'
        fragment on DiagnosticCode {
          id
          externalId
          name
          code
          identifier {
            value
          }
        }
      GRAPHQL

      PatientConditionFragment = Graphql::ValidationClient.parse <<-'GRAPHQL'
        fragment on PatientCondition {
          id
          externalId
          patient {
            id
            externalId
          }
          diagnosticCode {
            id
            externalId
          }
          identifier {
            value
          }
          onsetDate
          abatementDate
          status
        }
      GRAPHQL
    end
  end
end
