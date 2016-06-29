require 'spec_helper'

describe Datev::Account do
  describe :initialize do
    it "should be allowed with all required fields" do
      expect {
        Datev::Account.new(
          'Konto' => 1000
        )
      }.to_not raise_error
    end

    it "should not be allowed if fields are missing" do
      expect {
        Datev::Account.new 'Kontenbeschriftung' => 'Kasse'
      }.to raise_error(ArgumentError, "Value for field 'Konto' is required but missing")
    end
  end
end
