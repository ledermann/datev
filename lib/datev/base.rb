require 'datev/field'

module Datev
  class Base
    class << self
      attr_accessor :fields
    end

    attr_accessor :attributes

    def self.field(name, type, options={})
      self.fields ||= []

      # Check if there is already a field with the same name
      if self.fields.find { |f| f.name == name }
        raise ArgumentError.new("Field #{name} already exists")
      end

      self.fields << Field.new(name, type, options)
    end

    def initialize(attributes)
      self.attributes = {}

      raise ArgumentError.new('Hash required') unless attributes.is_a?(Hash)

      # Check existing name and set value (if valid)
      attributes.each_pair do |name,value|
        unless field = self.class.fields.find { |f| f.name == name }
          raise ArgumentError.new("Field #{name} not found")
        end

        field.validate!(value)
        self.attributes[name] = value
      end

      # Check for missing values
      self.class.fields.select(&:required?).each do |field|
        if attributes[field.name].nil?
          raise ArgumentError.new("Field #{field.name} is required but missing")
        end
      end
    end

    def to_a
      self.class.fields.map do |field|
        value = attributes[field.name]
        field.output(value)
      end
    end
  end
end
