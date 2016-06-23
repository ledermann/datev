require 'spec_helper'

describe Datev::Booking do
  describe :initialize do
    it "should be allowed with all required fields" do
      expect {
        Datev::Booking.new 'Umsatz (ohne Soll/Haben-Kz)'    => 100.12,
                           'Soll/Haben-Kennzeichen'         => 'S',
                           'Konto'                          => 1000,
                           'Gegenkonto (ohne BU-Schlüssel)' => 1200,
                           'Belegdatum'                     => Date.new(2016,6,20),
                           'Buchungstext'                   => 'ATM'
      }.to_not raise_error
    end

    it "should not be allowed if fields are missing" do
      expect {
        Datev::Booking.new 'Umsatz (ohne Soll/Haben-Kz)' => 100.12
      }.to raise_error(ArgumentError, "Value for field 'Soll/Haben-Kennzeichen' is required but missing")
    end

    it "should not be allowed for unknown fields names" do
      expect {
        Datev::Booking.new 'Umsatz' => 100.12
      }.to raise_error(ArgumentError, "Field 'Umsatz' not found")
    end
  end
end
