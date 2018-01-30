require 'spec_helper'

describe Datev::IntegerField do
  subject { Datev::IntegerField.new 'foo', limit: 3, minimum: 5, maximum: 500, required: true }

  describe :validate! do
    it "should accept valid value" do
      expect { subject.validate!(42) }.to_not raise_error
    end

    it "should fail for invalid values" do
      [ '123', 100.5, true ].each do |value|
        expect { subject.validate!(value) }.to raise_error(ArgumentError, "Value given for field 'foo' is not an Integer")
      end
      expect { subject.validate!(nil)     }.to raise_error(ArgumentError, "Value for field 'foo' is required")
    end

    it "should fail for too long value" do
      expect { subject.validate!(1000)    }.to raise_error(ArgumentError, "Value '1000' for field 'foo' is too long")
    end

    it "should fail for too small value" do
      expect { subject.validate!(4)       }.to raise_error(ArgumentError, "Value '4' for field 'foo' is too small")
    end

    it "should fail for too large value" do
      expect { subject.validate!(501)     }.to raise_error(ArgumentError, "Value '501' for field 'foo' is too large")
    end
  end

  describe :output do
    it "should return value as string" do
      expect(subject.output(1)).to eq('1')
    end
  end
end
