# frozen_string_literal: true

module Mirah
  module Filters
    # Input parameters and filters for queries returning {Data::PatientCondition} objects.
    class PatientConditionFilters < BaseObject
      # @!attribute [r] external_id
      #   @return [Array<string>] An array of external identifiers to match.
      attribute :external_id
    end
  end
end
