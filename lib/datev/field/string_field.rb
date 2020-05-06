module Datev
  class StringField < Field
    def limit
      options[:limit]
    end

    def regex
      options[:regex]
    end

    def validate!(value)
      super

      if value
        raise ArgumentError.new("Value given for field '#{name}' is not a String") unless value.is_a?(String)
        raise ArgumentError.new("Value '#{value}' for field '#{name}' is too long") if limit && value.length > limit
        raise ArgumentError.new("Value '#{value}' for field '#{name}' does not match regex") if regex && value !~ regex
      end
    end

    def output(value, _context=nil)
      value = value.slice(0, limit || 255) if value

      quote(value)
    end

  private

    def quote(value)
      # Existing quotes have to be doubled
      value = value.gsub('"','""') if value

      "\"#{value}\""
    end
  end
end
