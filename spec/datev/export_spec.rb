require 'spec_helper'

describe Datev::Export do
  let(:booking1) {
    Datev::Booking.new(
      'Belegdatum'                     => Date.new(2016,6,21),
      'Buchungstext'                   => 'Fachbuch: Controlling for Dummies',
      'Umsatz (ohne Soll/Haben-Kz)'    => 24.95,
      'Soll/Haben-Kennzeichen'         => 'H',
      'Konto'                          => 1200,
      'Gegenkonto (ohne BU-Schlüssel)' => 4940,
      'BU-Schlüssel'                   => '8'
    )
  }

  let(:booking2) {
    Datev::Booking.new(
      'Belegdatum'                     => Date.new(2016,6,22),
      'Buchungstext'                   => 'Honorar FiBu-Seminar',
      'Umsatz (ohne Soll/Haben-Kz)'    => 5950.00,
      'Soll/Haben-Kennzeichen'         => 'S',
      'Konto'                          => 10000,
      'Gegenkonto (ohne BU-Schlüssel)' => 8400,
      'Belegfeld 1'                    => 'RE201606-135'
    )
  }

  subject do
    export = Datev::Export.new(
      'Herkunft'        => 'XY',
      'Exportiert von'  => 'Chief Accounting Officer',
      'Berater'         => 123,
      'Mandant'         => 456,
      'WJ-Beginn'       => Date.new(2016,1,1),
      'Datum vom'       => Date.new(2016,6,1),
      'Datum bis'       => Date.new(2016,6,30),
      'Bezeichnung'     => 'Beispiel-Buchungen'
    )

    export << booking1
    export << booking2
    export
  end

  it 'should export as string' do
    csv_string = subject.to_s

    expect(csv_string).to be_a(String)
    expect(csv_string.lines.length).to eq(4)
    expect(csv_string).to include('4940')
    expect(csv_string).to include('Controlling for Dummies')
  end

  it 'should export a valid CSV file' do
    Dir.mktmpdir do |dir|
      filename = "#{dir}/EXTF_Buchungsstapel.csv"
      subject.to_file(filename)

      expect(File).to exist(filename)
      expect {
        CSV.read(filename)
      }.to_not raise_error
    end
  end
end
