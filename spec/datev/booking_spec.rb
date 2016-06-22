require 'spec_helper'

describe Datev::Booking do
  context "with all required fields" do
    it "should be allowed" do
      expect {
        Datev::Booking.new 'Umsatz (ohne Soll/Haben-Kz)'    => 100.12,
                           'Soll/Haben-Kennzeichen'         => 'S',
                           'Konto'                          => 1000,
                           'Gegenkonto (ohne BU-Schlüssel)' => 1200,
                           'Belegdatum'                     => Date.new(2016,6,20),
                           'Buchungstext'                   => 'ATM'
      }.to_not raise_error
    end
  end

  context "with missing fields" do
    it "should not be allowed" do
      expect {
        Datev::Booking.new 'Umsatz (ohne Soll/Haben-Kz)' => 100.12
      }.to raise_error(ArgumentError)
    end
  end

  context "with unknown field names " do
    it "should not be allowed" do
      expect {
        Datev::Booking.new 'Umsatz' => 100.12
      }.to raise_error(ArgumentError)
    end
  end
end
