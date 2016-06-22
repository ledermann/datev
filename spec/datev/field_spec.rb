require 'spec_helper'

describe Datev::Field do
  describe :initialize do
    it "should allow valid params" do
      Datev::Field.new 'foo', :string, :limit => 3
      Datev::Field.new 'foo', :integer, :limit => 3
      Datev::Field.new 'foo', :decimal, :precision => 10, :scale => 2
      Datev::Field.new 'foo', :boolean
      Datev::Field.new 'foo', :date, :format => '%d%m%Y'
    end

    it "should not allow invalid params" do
      expect {
        Datev::Field.new :foo, :xy
      }.to raise_error(ArgumentError)

      expect {
        Datev::Field.new 'foo', :xy
      }.to raise_error(ArgumentError)

      expect {
        Datev::Field.new 'foo', :string, :bar => 42
      }.to raise_error(ArgumentError)
    end
  end

  describe :validate! do
    let(:field) { Datev::Field.new 'foo', :string, :limit => 3, :required => true }

    it "should be true for valid value" do
      expect { field.validate!('Bar') }.to_not raise_error
    end

    it "should fail for invalid value" do
      expect { field.validate!('MuchTooLong') }.to raise_error(ArgumentError)
    end

    it "should fail for invalid value" do
      expect { field.validate!(nil) }.to raise_error(ArgumentError)
    end
  end
end
