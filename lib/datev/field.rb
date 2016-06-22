module Datev
  class Field
    attr_accessor :name, :type, :options

    def initialize(name, type, options={})
      unless name.is_a?(String)
        raise ArgumentError.new('Name param has to be a String')
      end

      unless [:string, :decimal, :boolean, :date, :integer].include?(type)
        raise ArgumentError.new('Type param not recognized')
      end

      unless options.is_a?(Hash)
        raise ArgumentError.new('Options param has to be a Hash')
      end

      unless (options.keys - [:limit, :required, :format, :precision, :scale]).empty?
        raise ArgumentError.new('Options param includes unknown key')
      end

      self.name = name
      self.type = type
      self.options = options
    end

    def required?
      options[:required] == true
    end

    def format
      options[:format]
    end

    def limit
      options[:limit]
    end

    def validate!(value)
      if value
        case type
        when :string
          raise ArgumentError.new("Field '#{name}' is not a String") unless value.is_a?(String)
          raise ArgumentError.new("Value '#{value}' fo field '#{name}' is too long") if limit && value.length > limit
        when :integer
          raise ArgumentError.new("Field '#{name}' is not an Integer") unless value.is_a?(Integer)
          raise ArgumentError.new("Value '#{value}' fo field '#{name}' is too long") if limit && value.to_s.length > limit
        when :decimal
          raise ArgumentError.new("Field '#{name}' is not a Numeric") unless value.is_a?(Numeric)
        when :date
          raise ArgumentError.new("Field '#{name}' is not a Date or Time") unless value.is_a?(Time) || value.is_a?(Date)
        when :boolean
          raise ArgumentError.new("Field '#{name}' is not a Boolean") unless [true, false].include?(value)
        end
      elsif required?
        raise ArgumentError.new("Field '#{name}' is required")
      end
    end

    def output(value)
      return unless value

      case type
      when :string
        value
      when :integer
        value.to_s.rjust(limit, '0')
      when :decimal
        value.to_s.sub('.',',')
      when :boolean
        value ? 1 : 0
      when :date
        value.strftime(format)
      end
    end
  end
end
