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

      # @!attribute [r] birth_date
      #   @return (see Mirah::Data::Patient#birth_date)
      input :birth_date, required: false, serializer: Serializers::DateSerializer

      # @!attribute [r] gender
      #   @return (see Mirah::Data::Patient#gender)
      input :gender, required: false

      # @!attribute [r] primary_language
      #   @return (see Mirah::Data::Patient#primary_language)
      input :primary_language, required: false

      # @!attribute [r] email
      #   @return (see Mirah::Data::Patient#email)
      input :email, required: false

      # @!attribute [r] phone_number
      #   @return (see Mirah::Data::Patient#phone_number)
      input :phone_number, required: false
    end
  end
end
