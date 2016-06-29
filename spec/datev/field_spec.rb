require 'spec_helper'

describe Datev::Field do
  describe :initialize do
    it 'should not allow invalid options' do
      expect {
        Datev::Field.new 'foo', 42
      }.to raise_error(ArgumentError, "Argument 'options' has to be a Hash")
    end

    it 'should not allow invalid name' do
      expect {
        Datev::Field.new :foo, :limit => 3
      }.to raise_error(ArgumentError, "Argument 'name' has to be a String")
    end
  end

  describe :validate! do
    context 'for required field' do
      subject { Datev::Field.new 'foo', :required => true }

      it 'should accept non-nil value' do
        expect { subject.validate!('bar') }.to_not raise_error
      end

      it 'should fail for nil value' do
        expect { subject.validate!(nil) }.to raise_error(ArgumentError, "Value for field 'foo' is required")
      end
    end

    context 'for not-required field' do
      subject { Datev::Field.new 'foo' }

      it 'should accept non-nil value' do
        expect { subject.validate!('bar') }.to_not raise_error
      end

      it 'should accept nil value' do
        expect { subject.validate!(nil) }.to_not raise_error
      end
    end
  end
end
