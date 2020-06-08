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
        }
      GRAPHQL
    end
  end
end
