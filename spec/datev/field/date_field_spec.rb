require 'spec_helper'

describe Datev::DateField do
  subject { Datev::DateField.new 'foo', format: "%m%Y", required: true }

  describe :validate! do
    it "should accept valid value" do
      expect { subject.validate!(Date.today)  }.to_not raise_error
      expect { subject.validate!(Time.now) }.to_not raise_error
    end

    it "should fail for invalid values" do
      [ 1000, '123', 100.5 ].each do |value|
        expect { subject.validate!(value) }.to raise_error(ArgumentError, "Value given for field 'foo' is not a Date or Time")
      end
      expect { subject.validate!(nil)     }.to raise_error(ArgumentError, "Value for field 'foo' is required")
    end
  end

  describe :output do
    it "should format using option" do
      expect(subject.output(Date.new(2016,3,28))).to eq('032016')
    end
  end
end
