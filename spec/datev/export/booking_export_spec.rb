# encoding: UTF-8
require 'spec_helper'

describe Datev::BookingExport do
  let(:booking1) {
    {
      'Belegdatum'                     => Date.new(2018,2,21),
      'Buchungstext'                   => 'Fachbuch: Controlling für Dummies',
      'Umsatz (ohne Soll/Haben-Kz)'    => 24.95,
      'Soll/Haben-Kennzeichen'         => 'H',
      'Konto'                          => 1200,
      'Gegenkonto (ohne BU-Schlüssel)' => 4940,
      'BU-Schlüssel'                   => '8'
    }
  }

  let(:booking2) {
    {
      'Belegdatum'                     => Date.new(2018,2,22),
      'Buchungstext'                   => 'Honorar FiBu-Seminar',
      'Umsatz (ohne Soll/Haben-Kz)'    => 5950.00,
      'Soll/Haben-Kennzeichen'         => 'S',
      'Konto'                          => 10000,
      'Gegenkonto (ohne BU-Schlüssel)' => 8400,
      'Belegfeld 1'                    => 'RE201802-135'
    }
  }

  let(:export) do
    export = Datev::BookingExport.new(
      'Herkunft'        => 'XY',
      'Exportiert von'  => 'Chief Accounting Officer',
      'Erzeugt am'      => Time.new(2018,3,6,10,25,0, '+02:00'),
      'Berater'         => 1001,
      'Mandant'         => 456,
      'WJ-Beginn'       => Date.new(2018,1,1),
      'Datum vom'       => Date.new(2018,2,1),
      'Datum bis'       => Date.new(2018,2,28),
      'Bezeichnung'     => 'Beispiel-Buchungen',
      'Festschreibung'  => false
    )

    export << booking1
    export << booking2
    export
  end

  describe :initialize do
    it "should accept Hash with valid keys" do
      expect {
        Datev::BookingExport.new(
          'Berater' => 1001,
          'Mandant' => 456
        )
      }.to_not raise_error
    end

    it "should accept blank Hash" do
      expect {
        Datev::BookingExport.new({})
      }.to_not raise_error
    end

    it "should not accept Hash with invalid keys" do
      expect {
        Datev::BookingExport.new(
          'foo' => 'bar'
        )
      }.to raise_error(ArgumentError, "Field 'foo' not found")
    end

    it "should not accept other types" do
      expect {
        Datev::BookingExport.new(42)
      }.to raise_error(ArgumentError, "Hash required")
    end
  end

  describe :<< do
    it "should accept Hash with valid keys" do
      expect {
        export << {
          'Belegdatum'                     => Date.today,
          'Umsatz (ohne Soll/Haben-Kz)'    => 24.95,
          'Soll/Haben-Kennzeichen'         => 'H',
          'Konto'                          => 1200,
          'Gegenkonto (ohne BU-Schlüssel)' => 4940
        }
      }.to_not raise_error
    end

    it "should not accept hash with missing keys" do
      expect {
        export << {}
      }.to raise_error(ArgumentError, "Value for field 'Umsatz (ohne Soll/Haben-Kz)' is required but missing")
    end

    it "should not accept other types" do
      expect {
        export << 42
      }.to raise_error(ArgumentError, "Hash required")
    end
  end

  describe :to_s do
    subject { export.to_s }

    it 'should export as string' do
      expect(subject).to be_a(String)
      expect(subject.lines.length).to eq(4)
    end

    it "should encode in Windows-1252" do
      expect(subject.encoding).to eq(Encoding::WINDOWS_1252)
    end

    it "should contain header" do
      expect(subject.lines[0]).to include('"EXTF";700')
    end

    it "should contain field names" do
      expect(subject.lines[1]).to include('Umsatz (ohne Soll/Haben-Kz);Soll/Haben-Kennzeichen')
    end

    it "should contain bookings" do
      expect(subject.lines[2]).to include('4940')
      expect(subject.lines[2].encode(Encoding::UTF_8)).to include('Controlling für Dummies')

      expect(subject.lines[3]).to include('8400')
      expect(subject.lines[3].encode(Encoding::UTF_8)).to include('Honorar FiBu-Seminar')
    end
  end

  describe :to_file do
    it 'should export a valid CSV file' do
      Dir.mktmpdir do |dir|
        filename = "#{dir}/EXTF_Buchungsstapel.csv"
        export.to_file(filename)

        expect {
          CSV.read(filename, **Datev::Export::CSV_OPTIONS)
        }.to_not raise_error
      end
    end

    it 'should export a file identically to the given example' do
      Dir.mktmpdir do |dir|
        filename = "#{dir}/EXTF_Buchungsstapel.csv"
        export.to_file(filename)
        if ENV['CREATE_EXAMPLES']
          export.to_file('examples/EXTF_Buchungsstapel.csv')
        end

        expect(IO.read(filename)).to eq(IO.read('examples/EXTF_Buchungsstapel.csv'))
      end
    end
  end
end
