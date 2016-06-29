module Datev
  class DecimalField < Field
    def precision
      options[:precision]
    end

    def scale
      options[:scale]
    end

    def validate!(value)
      super

      if value
        raise ArgumentError.new("Value given for field '#{name}' is not a Decimal") unless value.is_a?(Numeric)
        raise ArgumentError.new("Value '#{value}' for field '#{name}' is too long") if precision && value.to_s.length > precision+1
      end
    end

    def output(value, _context=nil)
      ("%.#{scale}f" % value).sub('.',',') if value
    end
  end
end
