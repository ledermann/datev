require 'spec_helper'

describe Datev::Header do
  describe :initialize do
    it "should be allowed with defined fields" do
      expect {
        Datev::Header.new(
          'Berater' => 123,
          'Mandant' => 456
          )
      }.to_not raise_error
    end

    it "should not be allowed without argument" do
      expect {
        Datev::Header.new
      }.to raise_error(ArgumentError)
    end

    it "should not be allowed with unknown field names" do
      expect {
        Datev::Header.new(
          'Foo' => 100.12
        )
      }.to raise_error(ArgumentError)
    end
  end
end
