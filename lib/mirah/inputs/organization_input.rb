# frozen_string_literal: true

module Mirah
  module Inputs
    # A set of parameters for updating a {Data::Organization}
    class OrganizationInput < BaseInputObject
      # @!attribute [r] external_id
      #   @return (see Mirah::Data::Organization#external_id)
      input :external_id, required: true

      # @!attribute [r] name
      #   @return (see Mirah::Data::Organization#name)
      input :name, required: false

      # @!attribute [r] external_part_of_id
      #   @return (see Mirah::Data::Organization#external_part_of_id)
      input :external_part_of_id, required: false
    end
  end
end
