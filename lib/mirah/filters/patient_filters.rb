# frozen_string_literal: true

module Mirah
  module Filters
    # Input parameters and filters for queries returning {Data::Patient} objects.
    class PatientFilters < BaseObject
      # @!attribute [r] external_id
      #   @return [Array<string>] An array of external identifiers to match.
      attribute :external_id

      # @!attribute [r] search
      #   @return [string] Smart search by name and other fields where appropriate
      attribute :search
    end
  end
end
