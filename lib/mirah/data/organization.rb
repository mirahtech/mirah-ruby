# frozen_string_literal: true

module Mirah
  module Data
    # Organizations in the Mirah system currently represent a hierarchy of units/facilities
    # requiring either different treatment configurations (e.g. inpatient facilities require different
    # measurement protocols to outpatient) or useful for the purpose of analytics. It is roughly based on
    # https://www.hl7.org/fhir/organization.html
    class Organization < BaseObject
      # @!attribute [r] id
      #   @return [string] The internal Mirah identifier
      attribute :id

      # @!attribute [r] external_id
      #   @return [string] The identifier provided by your system
      attribute :external_id

      # @!attribute [r] name
      #   @return [string] The organization's name
      attribute :name

      # @!attribute [r] part_of_id
      #   @return [string] The internal mirah id of the organization this organization is a child of
      attribute :part_of_id, path: %w[partOf], target: 'id'

      # @!attribute [r] external_part_of_id
      #   @return [string] Your system identifier for the organization this organization is a child of
      attribute :external_part_of_id, path: %w[partOf], target: 'externalId'
    end
  end
end
