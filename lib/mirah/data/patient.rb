# frozen_string_literal: true

module Mirah
  module Data
    # Patients represent people who are in treatment. They can have appointments, and be the target of assessments.
    # Patients are only treated in the context of an episode of care.
    class Patient < BaseObject
      # @!attribute [r] id
      #   @return [string] The internal Mirah identifier
      attribute :id

      # @!attribute [r] external_id
      #   @return [string] The identifier provided by your system
      attribute :external_id

      # @!attribute [r] given_name
      #   @return [string] The patient's first or given name
      # @deprecated use legal_given_name instead
      attribute :given_name

      # @!attribute [r] legal_given_name
      #   @return [string] The patient's legal first or given name
      attribute :legal_given_name

      # @!attribute [r] preferred_given_name
      #   @return [string] The patient's preferred first or given name
      attribute :preferred_given_name

      # @!attribute [r] family_name
      #   @return [string] The patient's last or family name
      # @deprecated use legal_family_name instead
      attribute :family_name

      # @!attribute [r] legal_family_name
      #   @return [string] The patient's legal last or family name
      attribute :legal_family_name

      # @!attribute [r] preferred_family_name
      #   @return [string] The patient's preferred last or family name
      attribute :preferred_family_name

      # @!attribute [r] legal_name
      #   @return [string] The patient's full legal name.
      attribute :legal_name

      # @!attribute [r] preferred_name
      #   @return [string] The patient's full preferred name.
      attribute :preferred_name

      # @!attribute [r] preferred_pronouns
      #   @return [string] The patient's preferred pronouns.
      attribute :preferred_pronouns

      # @!attribute [r] birth_date
      #   @return [Date] The patient's date of birth.
      attribute :birth_date, serializer: Serializers::DateSerializer.new

      # @!attribute [r] gender
      #   @return [string] The patient's gender
      attribute :gender

      # @!attribute [r] gender_identity
      #   @return [string] The patient's gender identity as free text
      attribute :gender_identity

      # @!attribute [r] gender_identity_fhir
      #   @return [string] The patient's gender identity as FHIR extension coded.
      attribute :gender_identity_fhir

      # @!attribute [r] primary_language
      #   @return [string] The patient's primary language
      attribute :primary_language

      # @!attribute [r] email
      #   @return [string] The patient's primary email address
      attribute :email

      # @!attribute [r] phone_number
      #   @return [string] The patient's primary phone number that is suitable for receiving text messages.
      #    Please do not use a phone number which corresponds to a landline as text messages will not be received.
      attribute :phone_number

      # @!attribute [r] timezone
      #   @return [string] The patient's timezone. If not specified, the organization's default will be used. Timezone
      #    should be formatted like: https://en.wikipedia.org/wiki/Tz_database
      attribute :timezone

      # @!attribute [r] managing_organization_id
      #   @return [string] The internal mirah id of the organization this patient is with
      attribute :managing_organization_id, path: %w[managingOrganization], target: 'id'

      # @!attribute [r] external_managing_organization_id
      #   @return [string] Your system identifier for the organization this patient is with
      attribute :external_managing_organization_id, path: %w[managingOrganization], target: 'externalId'
    end
  end
end
