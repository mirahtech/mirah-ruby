# frozen_string_literal: true

module Mirah
  module Filters
    # Input parameters and filters for queries returning {Data::Appointment} objects.
    class AppointmentFilters < BaseObject
      # @!attribute [r] external_id
      #   @return [Array<string>] An array of external identifiers to match.
      attribute :external_id

      # @!attribute [r] status
      #   @return [string] The appointment status
      attribute :status
    end
  end
end
