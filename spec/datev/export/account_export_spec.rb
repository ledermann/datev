require 'spec_helper'

describe Datev::AccountExport do
  let(:account1) {
    {
      'Konto'              => 400,
      'Kontenbeschriftung' => 'Betriebsausstattung',
      'Sprach-ID'          => 'de-DE'
    }
  }

  let(:account2) {
    {
      'Konto'              => 1000,
      'Kontenbeschriftung' => 'Kasse',
      'Sprach-ID'          => 'de-DE'
    }
  }

  let(:account3) {
    {
      'Konto'              => 1200,
      'Kontenbeschriftung' => 'Girokonto',
      'Sprach-ID'          => 'de-DE'
    }
  }

  let(:export) do
    export = Datev::AccountExport.new(
      'Herkunft'        => 'XY',
      'Exportiert von'  => 'Chief Accounting Officer',
      'Erzeugt am'      => Time.new(2018,2,23,15,25,0, '+02:00'),
      'Berater'         => 1001,
      'Mandant'         => 456,
      'WJ-Beginn'       => Date.new(2018,1,1),
      'Bezeichnung'     => 'Beispiel-Konten'
    )

    export << account1
    export << account2
    export << account3
    export
  end

  describe :to_s do
    subject { export.to_s }

    it 'should export as string' do
      expect(subject).to be_a(String)
      expect(subject.lines.length).to eq(5)
    end

    it "should encode in Windows-1252" do
      expect(subject.encoding).to eq(Encoding::WINDOWS_1252)
    end

    it "should contain header" do
      expect(subject.lines[0]).to include('"EXTF";820')
    end

    it "should contain field names" do
      expect(subject.lines[1]).to include('Konto;Kontenbeschriftung')
    end

    it "should contain accounts" do
      expect(subject.lines[2]).to include('400;"Betriebsausstattung"')
      expect(subject.lines[3]).to include('1000;"Kasse"')
      expect(subject.lines[4]).to include('1200;"Girokonto"')
    end
  end

  describe :to_file do
    it 'should export a valid CSV file' do
      Dir.mktmpdir do |dir|
        filename = "#{dir}/EXTF_Kontenbeschriftungen.csv"
        export.to_file(filename)

        expect {
          CSV.read(filename, Datev::Export::CSV_OPTIONS)
        }.to_not raise_error
      end
    end

    it 'should export a file identically to the given example' do
      Dir.mktmpdir do |dir|
        filename = "#{dir}/EXTF_Kontenbeschriftungen.csv"
        export.to_file(filename)
        if ENV['CREATE_EXAMPLES']
          export.to_file('examples/EXTF_Kontenbeschriftungen.csv')
        end

        expect(IO.read(filename)).to eq(IO.read('examples/EXTF_Kontenbeschriftungen.csv'))
      end
    end
  end

end
