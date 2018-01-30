require 'spec_helper'

describe Datev::StringField do
  subject { Datev::StringField.new 'foo', limit: 9, required: true }

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
    describe "quoting" do
      it "should add quotes" do
        expect(subject.output('foo')).to eq('"foo"')
      end

      it "should quote nil value" do
        expect(subject.output(nil)).to eq('""')
      end

      it "should handle single quotes" do
        expect(subject.output("Kaiser's")).to eq('"Kaiser\'s"')
      end

      it "should duplicate existing double quotes" do
        expect(subject.output('"ZEIT"ung')).to eq('"""ZEIT""ung"')
      end
    end

    it "should truncate string to limit" do
      expect(subject.output('1234567890')).to eq('"123456789"')
    end
  end
end
