# frozen_string_literal: true

module Mirah
  module Data
    # Diagnostic codes represent ICD10 or other codes that contain information on diagnosis. The Mirah system models
    # this simply as a code and a name, effectively operating like a tag.
    # For example, Major Depressive Disorder could be represented with the code F320.
    class DiagnosticCode < BaseObject
      # @!attribute [r] id
      #   @return [string] The internal Mirah identifier
      attribute :id

      # @!attribute [r] external_id
      #   @return [string] The identifier provided by your system
      attribute :external_id

      # @!attribute [r] name
      #   @return [string] A description of the code, e.g. "Major Depressive Disorder"
      attribute :name

      # @!attribute [r] code
      #   @return [string] A string representing the code, e.g. "F320"
      attribute :code
    end
  end
end
