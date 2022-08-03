# frozen_string_literal: true

module Mirah
  module Inputs
    # A set of parameters for updating a {Data::DiagnosticCocde}
    class DiagnosticCodeInput < BaseInputObject
      # @!attribute [r] external_id
      #   @return (see Mirah::Data::DiagnosticCode#external_id)
      input :external_id, required: true

      # @!attribute [r] name
      #   @return (see Mirah::Data::DiagnosticCode#name)
      input :name, required: false

      # @!attribute [r] name
      #   @return (see Mirah::Data::DiagnosticCode#code)
      input :code, required: false
    end
  end
end
