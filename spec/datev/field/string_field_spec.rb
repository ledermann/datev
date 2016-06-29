require 'spec_helper'

describe Datev::StringField do
  subject { Datev::StringField.new 'foo', :limit => 3, :required => true }

  describe :validate! do
    it "should accept valid value" do
      expect { subject.validate!('Bar') }.to_not raise_error
    end

    it "should fail for invalid values" do
      [ 123, 123.45, true ].each do |value|
        expect { subject.validate!(value)       }.to raise_error(ArgumentError, "Value given for field 'foo' is not a String")
      end
      expect { subject.validate!('MuchTooLong') }.to raise_error(ArgumentError, "Value 'MuchTooLong' for field 'foo' is too long")
      expect { subject.validate!(nil)           }.to raise_error(ArgumentError, "Value for field 'foo' is required")
    end
  end

  describe :output do
    it "should return unchanged value" do
      expect(subject.output('foo')).to eq('foo')
    end

    it "should truncate string to limit" do
      expect(subject.output('1234567')).to eq('123')
    end
  end
end
