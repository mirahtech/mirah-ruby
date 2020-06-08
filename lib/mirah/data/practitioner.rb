# frozen_string_literal: true

module Mirah
  module Data
    # FHIR Practitioners represent people directly involved in the provision of care.
    # See https://www.hl7.org/fhir/practitioner.html for more details.
    class Practitioner < BaseObject
      # @!attribute [r] id
      #   @return [string] The internal Mirah identifier
      attribute :id

      # @!attribute [r] external_id
      #   @return [string] The identifier provided by your system
      attribute :external_id

      # @!attribute [r] given_name
      #   @return [string] The practitioner's first or given name
      attribute :given_name

      # @!attribute [r] family_name
      #   @return [string] The practitioner's last or family name
      attribute :family_name

      # @!attribute [r] title
      #   @return [string] The practitioner's title, e.g. 'Dr'
      attribute :title

      # @!attribute [r] suffix
      #   @return [string] The practitioner's suffix, e.g. 'MD'
      attribute :suffix

      # @!attribute [r] email
      #   @return [string] The practitioner's primary email address
      attribute :email

      # @!attribute [r] default_practitioner_role
      #   @return [string] The clinical role for this practitioner
      attribute :default_practitioner_role

      # @!attribute [r] sso_username
      #   @return [string] The username (nameid) used for single sign on by this practitioner.
      attribute :sso_username

      # @!attribute [r] organization_ids
      #   @return [Array<string>] The internal mirah organization ids this practitioner has a role in
      attribute :organization_ids, path: %w[organization], target: 'id'

      # @!attribute [r] external_organization_ids
      #   @return [Array<string>] The identifiers from your system of the organizations this practitioner has a role in
      attribute :external_organization_ids, path: %w[organizations], target: 'externalId'
    end
  end
end
