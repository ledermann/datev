require 'spec_helper'

describe Datev::Contact do
  describe :initialize do
    it "should be allowed with all required fields" do
      expect {
        Datev::Contact.new(
          'Konto' => 10000
        )
      }.to_not raise_error
    end

    it "should not be allowed if fields are missing" do
      expect {
        Datev::Contact.new 'Name (Adressatentyp Unternehmen)' => 'Meyer GmbH'
      }.to raise_error(ArgumentError, "Value for field 'Konto' is required but missing")
    end
  end
end
