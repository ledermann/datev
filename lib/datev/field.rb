module Datev
  class Field
    attr_accessor :name, :options, :block

    def initialize(name, options={}, &block)
      unless name.is_a?(String)
        raise ArgumentError.new("Argument 'name' has to be a String")
      end

      unless options.is_a?(Hash)
        raise ArgumentError.new("Argument 'options' has to be a Hash")
      end

      self.name = name
      self.options = options

      if block_given?
        self.instance_eval(&block)
      end
    end

    def required?
      options[:required] == true
    end

    def validate!(value)
      if value.nil?
        raise ArgumentError.new("Value for field '#{name}' is required") if required?
      end
    end
  end
end
