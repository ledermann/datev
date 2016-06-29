require 'spec_helper'

describe Datev::BooleanField do
  subject { Datev::BooleanField.new 'foo', :required => true }

  describe :validate! do
    it 'should accept valid value' do
      expect { subject.validate!(true)  }.to_not raise_error
      expect { subject.validate!(false) }.to_not raise_error
    end

    it 'should fail for invalid values' do
      [ 1000, '123', 100.5 ].each do |value|
        expect { subject.validate!(value) }.to raise_error(ArgumentError, "Value given for field 'foo' is not a Boolean")
      end
      expect { subject.validate!(nil)     }.to raise_error(ArgumentError, "Value for field 'foo' is required")
    end
  end

  describe :output do
    it 'should return 0 or 1' do
      expect(subject.output(true)).to eq(1)
      expect(subject.output(false)).to eq(0)
    end
  end
end
