# frozen_string_literal: true

module Mirah
  module Graphql
    # @private
    module Queries # rubocop:disable Metrics/ModuleLength
      #========================================================================
      # PATIENT QUERIES
      #========================================================================

      PatientQuery = Graphql::ValidationClient.parse <<-'GRAPHQL'
        query(
          $first: Int
          $last: Int
          $after: String
          $before: String,
          $externalId: [String!],
          $search: String
        ) {
          patients(
            first: $first
            after: $after
            before: $before
            last: $last,
            externalId: $externalId,
            search: $search
          ) {
            nodes {
              ...Mirah::Graphql::Fragments::PatientFragment
            }
            pageInfo {
              ...Mirah::Graphql::Fragments::PageInfoFragment
            }
          }
        }
      GRAPHQL

      PatientIdQuery = Graphql::ValidationClient.parse <<-'GRAPHQL'
        query($id: ID!) {
          patient(id: $id) {
            ...Mirah::Graphql::Fragments::PatientFragment
          }
        }
      GRAPHQL

      PatientExternalIdQuery = Graphql::ValidationClient.parse <<-'GRAPHQL'
        query($externalId: String!) {
          patientExternal(externalId: $externalId) {
            ...Mirah::Graphql::Fragments::PatientFragment
          }
        }
      GRAPHQL

      #========================================================================
      # ORGANIZATION QUERIES
      #========================================================================

      OrganizationQuery = Graphql::ValidationClient.parse <<-'GRAPHQL'
        query(
          $first: Int
          $last: Int
          $after: String
          $before: String,
          $externalId: [String!],
          $search: String
        ) {
          organizations(
            first: $first
            after: $after
            before: $before
            last: $last,
            externalId: $externalId,
            search: $search
          ) {
            nodes {
              ...Mirah::Graphql::Fragments::OrganizationFragment
            }
            pageInfo {
              ...Mirah::Graphql::Fragments::PageInfoFragment
            }
          }
        }
      GRAPHQL

      OrganizationIdQuery = Graphql::ValidationClient.parse <<-'GRAPHQL'
        query($id: ID!) {
          organization(id: $id) {
            ...Mirah::Graphql::Fragments::OrganizationFragment
          }
        }
      GRAPHQL

      OrganizationExternalIdQuery = Graphql::ValidationClient.parse <<-'GRAPHQL'
        query($externalId: String!) {
          organizationExternal(externalId: $externalId) {
            ...Mirah::Graphql::Fragments::OrganizationFragment
          }
        }
      GRAPHQL

      #========================================================================
      # PRACTITIONER QUERIES
      #========================================================================

      PractitionerQuery = Graphql::ValidationClient.parse <<-'GRAPHQL'
        query(
          $first: Int
          $last: Int
          $after: String
          $before: String,
          $externalId: [String!]
          $search: String
        ) {
          practitioners(
            first: $first
            after: $after
            before: $before
            last: $last,
            externalId: $externalId,
            search: $search
          ) {
            nodes {
              ...Mirah::Graphql::Fragments::PractitionerFragment
            }
            pageInfo {
              ...Mirah::Graphql::Fragments::PageInfoFragment
            }
          }
        }
      GRAPHQL

      PractitionerIdQuery = Graphql::ValidationClient.parse <<-'GRAPHQL'
        query($id: ID!) {
          practitioner(id: $id) {
            ...Mirah::Graphql::Fragments::PractitionerFragment
          }
        }
      GRAPHQL

      PractitionerExternalIdQuery = Graphql::ValidationClient.parse <<-'GRAPHQL'
        query($externalId: String!) {
          practitionerExternal(externalId: $externalId) {
            ...Mirah::Graphql::Fragments::PractitionerFragment
          }
        }
      GRAPHQL

      #========================================================================
      # APPOINTMENT QUERIES
      #========================================================================

      AppointmentQuery = Graphql::ValidationClient.parse <<-'GRAPHQL'
        query(
          $first: Int
          $last: Int
          $after: String
          $before: String,
          $externalId: [String!]
          $status: [AppointmentStatus!]
        ) {
          appointments(
            first: $first
            after: $after
            before: $before
            last: $last,
            externalId: $externalId,
            status: $status
          ) {
            nodes {
              ...Mirah::Graphql::Fragments::AppointmentFragment
            }
            pageInfo {
              ...Mirah::Graphql::Fragments::PageInfoFragment
            }
          }
        }
      GRAPHQL

      AppointmentIdQuery = Graphql::ValidationClient.parse <<-'GRAPHQL'
        query($id: ID!) {
          appointment(id: $id) {
            ...Mirah::Graphql::Fragments::AppointmentFragment
          }
        }
      GRAPHQL

      AppointmentExternalIdQuery = Graphql::ValidationClient.parse <<-'GRAPHQL'
        query($externalId: String!) {
          appointmentExternal(externalId: $externalId) {
            ...Mirah::Graphql::Fragments::AppointmentFragment
          }
        }
      GRAPHQL
    end
  end
end
