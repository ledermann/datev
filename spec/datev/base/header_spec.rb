require 'spec_helper'

describe Datev::Header do
  describe :initialize do
    it "should be allowed with defined fields" do
      expect {
        Datev::Header.new(
          'Berater' => 1001,
          'Mandant' => 456
          )
      }.to_not raise_error
    end

    it "should not be allowed with unknown field names" do
      expect {
        Datev::Header.new(
          'Foo' => 100.12
        )
      }.to raise_error(ArgumentError, "Field 'Foo' not found")
    end
  end
end
