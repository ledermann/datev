require 'spec_helper'

describe Datev::DecimalField do
  subject { Datev::DecimalField.new 'foo', :precision => 6, :scale => 2, :required => true }

  describe :validate! do
    it "should accept valid value" do
      expect { subject.validate!(12.23)  }.to_not raise_error
    end

    it "should fail for invalid values" do
      [ '123', true, Date.new(2016,1,1) ].each do |value|
        expect { subject.validate!(value) }.to raise_error(ArgumentError, "Value given for field 'foo' is not a Decimal")
      end
      expect { subject.validate!(100000.5)}.to raise_error(ArgumentError, "Value '100000.5' for field 'foo' is too long")
      expect { subject.validate!(nil)     }.to raise_error(ArgumentError, "Value for field 'foo' is required")
    end
  end

  describe :output do
    it "should format" do
      expect(subject.output(1)).to eq('1,00')
      expect(subject.output(10)).to eq('10,00')
      expect(subject.output(1.2)).to eq('1,20')
      expect(subject.output(10.21)).to eq('10,21')
      expect(subject.output(1.238)).to eq('1,24')
    end
  end
end
