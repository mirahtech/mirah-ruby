# frozen_string_literal: true

module Mirah
  module Inputs
    # A set of parameters for updating a {Data::Practitioner}
    class PractitionerInput < BaseInputObject
      # @!attribute [r] external_id
      #   @return (see Mirah::Data::Practitioner#external_id)
      input :external_id, required: true

      # @!attribute [r] given_name
      #   @return (see Mirah::Data::Practitioner#given_name)
      input :given_name, required: false

      # @!attribute [r] family_name
      #   @return (see Mirah::Data::Practitioner#family_name)
      input :family_name, required: false

      # @!attribute [r] title
      #   @return (see Mirah::Data::Practitioner#title)
      input :title, required: false

      # @!attribute [r] suffix
      #   @return (see Mirah::Data::Practitioner#suffix)
      input :suffix, required: false

      # @!attribute [r] email
      #   @return (see Mirah::Data::Practitioner#email)
      input :email, required: false

      # @!attribute [r] default_practitioner_role
      #   @return (see Mirah::Data::Practitioner#default_practitioner_role)
      input :default_practitioner_role, required: false

      # @!attribute [r] sso_username
      #   @return (see Mirah::Data::Practitioner#sso_username)
      input :sso_username, required: false

      # @!attribute [r] external_organization_ids
      #   @return (see Mirah::Data::Practitioner#external_organization_ids)
      input :external_organization_ids, required: false
    end
  end
end
