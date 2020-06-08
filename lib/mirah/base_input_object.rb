# frozen_string_literal: true

module Mirah
  # This object provides a DSL by which you can easy create plain ruby objects with `attr_accessor` that will
  # automatically be transformed back and forth from a GraphQL endpoint. This includes changing the format of the
  # key from `ruby_style` to `graphqlStyle` and back again, and extra serialization where necessary for scalar types
  # such as dates.
  class BaseInputObject
    def initialize(attrs = {})
      attrs.each do |key, value|
        raise Errors::InvalidParameter.new(key), "#{key} is not a valid parameter" unless respond_to? "#{key}="

        send("#{key}=", value)
      end
    end

    def valid?
      self.class.inputs.all? do |input|
        !input[:required] || send(input[:name])
      end
    end

    def validate!
      self.class.inputs.all? do |input|
        if input[:required] && !send(input[:name])
          raise Errors::MissingParameter.new(input[:name]), "#{input[:name]} is missing"
        end
      end
    end

    def to_graphql_hash
      self.class.inputs.each_with_object({}) do |input, obj|
        value = input[:serializer].serialize(send(input[:name]))
        obj[input[:graphql_name]] = value if value
      end
    end

    def self.from_graphql_hash(graphql_data)
      return nil unless graphql_data

      attrs = inputs.each_with_object({}) do |input, obj|
        value = graphql_data[input[:graphql_name]]
        obj[input[:name]] = input[:serializer].deserialize(value)
      end

      new(attrs)
    end

    # @private
    def self.inputs
      @inputs ||= []
    end

    # @private
    def self.input(name, required:, serializer: Serializers::ScalarSerializer)
      inputs.push(
        { name: name,
          serializer: serializer,
          required: required,
          graphql_name: name.to_s.camelize(:lower) }
      )
      attr_accessor name
    end
  end
end
