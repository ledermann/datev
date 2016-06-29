module Datev
  class Base
    class << self
      attr_accessor :fields, :default_attributes

      def inherited(subclass)
        subclass.fields             = self.fields
        subclass.default_attributes = self.default_attributes
      end
    end

    def self.field(name, type, options={}, &block)
      self.fields ||= []

      # Check if there is already a field with the same name
      if field_by_name(name)
        raise ArgumentError.new("Field '#{name}' already exists")
      end

      field_class = const_get("Datev::#{type.to_s.capitalize}Field")
      self.fields << field_class.new(name, options, &block)
    end

    def self.field_by_name(name)
      self.fields.find { |f| f.name == name }
    end

    def initialize(attributes)
      raise ArgumentError.new('Hash required') unless attributes.is_a?(Hash)

      @attributes = self.class.default_attributes || {}

      # Check existing names and set value (if valid)
      attributes.each_pair do |name,value|
        unless field = self.class.field_by_name(name)
          raise ArgumentError.new("Field '#{name}' not found")
        end

        field.validate!(value)
        @attributes[name] = value
      end

      # Check for missing values
      self.class.fields.select(&:required?).each do |field|
        if @attributes[field.name].nil?
          raise ArgumentError.new("Value for field '#{field.name}' is required but missing")
        end
      end
    end

    def [](name)
      field = self.class.field_by_name(name)
      raise ArgumentError.new("Field '#{name}' not found") unless field

      @attributes[field.name]
    end

    def output(context=nil)
      self.class.fields.map do |field|
        value = @attributes[field.name]
        field.output(value, context)
      end
    end
  end
end
