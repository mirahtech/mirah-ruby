# frozen_string_literal: true

module Mirah
  # This object provides a DSL by which you can easy create plain ruby objects with `attr_accessor` that will
  # automatically be transformed back and forth from a GraphQL endpoint. This includes changing the format of the
  # key from `ruby_style` to `graphqlStyle` and back again, and extra serialization where necessary for scalar types
  # such as dates.
  class BaseObject
    def initialize(attrs = {})
      attrs.each do |key, value|
        send("#{key}=", value)
      end
    end

    def to_graphql_hash
      self.class.attributes.each_with_object({}) do |attribute, obj|
        value = attribute[:serializer].serialize(send(attribute[:name]))
        write_value(obj, value, attribute)
      end
    end

    def self.from_graphql_hash(graphql_data)
      return nil unless graphql_data

      attrs = attributes.each_with_object({}) do |attribute, obj|
        value = read_value(graphql_data, attribute)
        obj[attribute[:name]] = attribute[:serializer].deserialize(value)
      end

      new(attrs)
    end

    # @private
    def self.attributes
      @attributes ||= []
    end

    # @private
    def self.attribute(name, serializer: Serializers::ScalarSerializer.new, target: name, path: nil)
      attributes.push(
        {
          name: name,
          serializer: serializer,
          path: path,
          graphql_name: target.to_s.camelize(:lower)
        }
      )
      attr_accessor name
    end

    private

    def write_value(object, value, attribute)
      object_to_write = object

      object_to_write = write_nested_value(object, attribute[:path].dup) if attribute[:path]

      object_to_write[attribute[:graphql_name]] = value if value
    end

    def write_nested_value(object, path)
      current_obj = object

      loop do
        path_part = path.shift
        current_obj[path_part] ||= {}
        current_obj = current_obj[path_part]
        break current_obj unless path&.length&.positive?
      end
    end

    class << self
      private

      def read_value(graphql_data, attribute)
        if attribute[:path]
          read_nested_path(graphql_data, attribute[:path].dup, attribute[:graphql_name])
        elsif graphql_data
          graphql_data[attribute[:graphql_name]]
        end
      end

      def read_nested_path(data, path, target)
        return data[target] unless path&.length&.positive?

        new_data = data[path.shift]

        return nil unless new_data

        if new_data.is_a? Array
          new_data.map { |item| read_nested_path(item, path, target) }
        else
          read_nested_path(new_data, path, target)
        end
      end
    end
  end
end
