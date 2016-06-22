require 'spec_helper'

describe Datev::Export do
  let(:booking1) {
    Datev::Booking.new 'Umsatz (ohne Soll/Haben-Kz)'    => 100.12,
                       'Soll/Haben-Kennzeichen'         => 'S',
                       'Konto'                          => 1000,
                       'Gegenkonto (ohne BU-Schlüssel)' => 1200,
                       'Belegdatum'                     => Date.new(2016,6,20),
                       'Buchungstext'                   => 'Geldautomat'
  }

  let(:booking2) {
    Datev::Booking.new 'Umsatz (ohne Soll/Haben-Kz)'    => 14.50,
                       'Soll/Haben-Kennzeichen'         => 'H',
                       'Konto'                          => 1200,
                       'Gegenkonto (ohne BU-Schlüssel)' => 4910,
                       'Belegdatum'                     => Date.new(2016,6,21),
                       'Buchungstext'                   => 'Briefmarken'
  }

  subject do
    export = Datev::Export.new 'Herkunft'        => 'RB',
                               'Exportiert von'  => 'Chief Accounting Officer',
                               'Berater'         => 123,
                               'Mandant'         => 456,
                               'WJ-Beginn'       => Date.new(2016,1,1),
                               'Datum vom'       => Date.new(2016,1,1),
                               'Datum bis'       => Date.new(2016,12,31)

    export << booking1
    export << booking2
    export
  end

  it 'should export as string' do
    csv_string = subject.to_s

    expect(csv_string).to be_a(String)
    expect(csv_string.lines.length).to eq(4)
    expect(csv_string).to include('1200')
    expect(csv_string).to include('Briefmarken')
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
