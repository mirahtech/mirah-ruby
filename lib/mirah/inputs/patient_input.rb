# frozen_string_literal: true

module Mirah
  module Inputs
    # A set of parameters for updating a {Data::Patient}
    class PatientInput < BaseInputObject
      # @!attribute [r] external_id
      #   @return (see Mirah::Data::Patient#external_id)
      input :external_id, required: true

      # @!attribute [r] given_name
      #   @return (see Mirah::Data::Patient#given_name)
      input :given_name, required: false

      # @!attribute [r] family_name
      #   @return (see Mirah::Data::Patient#family_name)
      input :family_name, required: false

      # @!attribute [r] preferred_given_name
      #   @return (see Mirah::Data::Patient#preferred_given_name)
      input :preferred_given_name, required: false

      # @!attribute [r] preferred_family_name
      #   @return (see Mirah::Data::Patient#preferred_family_name)
      input :preferred_family_name, required: false

      # @!attribute [r] legal_given_name
      #   @return (see Mirah::Data::Patient#legal_given_name)
      input :legal_given_name, required: false

      # @!attribute [r] legal_family_name
      #   @return (see Mirah::Data::Patient#legal_family_name)
      input :legal_family_name, required: false

      # @!attribute [r] preferred_name
      #   @return (see Mirah::Data::Patient#preferred_name)
      input :preferred_name, required: false

      # @!attribute [r] legal_name
      #   @return (see Mirah::Data::Patient#legal_name)
      input :legal_name, required: false

      # @!attribute [r] preferred_pronouns
      #   @return (see Mirah::Data::Patient#preferred_pronouns)
      input :preferred_pronouns, required: false

      # @!attribute [r] birth_date
      #   @return (see Mirah::Data::Patient#birth_date)
      input :birth_date, required: false, serializer: Serializers::DateSerializer.new

      # @!attribute [r] gender
      #   @return (see Mirah::Data::Patient#gender)
      input :gender, required: false

      # @!attribute [r] gender_identity
      #   @return (see Mirah::Data::Patient#gender_identity)
      input :gender_identity, required: false

      # @!attribute [r] gender_identity_fhir
      #   @return (see Mirah::Data::Patient#gender_identity_fhir)
      input :gender_identity_fhir, required: false

      # @!attribute [r] primary_language
      #   @return (see Mirah::Data::Patient#primary_language)
      input :primary_language, required: false

      # @!attribute [r] email
      #   @return (see Mirah::Data::Patient#email)
      input :email, required: false

      # @!attribute [r] phone_number
      #   @return (see Mirah::Data::Patient#phone_number)
      input :phone_number, required: false

      # @!attribute [r] phone_number
      #   @return (see Mirah::Data::Patient#timezone)
      input :timezone, required: false

      # @!attribute [r] external_managing_organization_id
      #   @return (see Mirah::Data::Patient#external_managing_organization_id)
      input :external_managing_organization_id, required: false
    end
  end
end
