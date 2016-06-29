require 'datev/field'

module Datev
  class StringField < Field
    def limit
      options[:limit]
    end

    def validate!(value)
      super

      if value
        raise ArgumentError.new("Value given for field '#{name}' is not a String") unless value.is_a?(String)
        raise ArgumentError.new("Value '#{value}' for field '#{name}' is too long") if limit && value.length > limit
      end
    end

    def output(value, _context=nil)
      value.slice(0, limit || 255) if value
    end
  end
end
