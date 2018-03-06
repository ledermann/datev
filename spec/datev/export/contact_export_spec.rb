require 'spec_helper'

describe Datev::ContactExport do
  let(:contact1) {
    {
      'Konto'                                  => 10000,
      'Vorname (Adressatentyp natürl. Person)' => 'Sabine',
      'Name (Adressatentyp natürl. Person)'    => 'Mustermann',
      'Adressatentyp'                          => '1',
      'Anrede'                                 => 'Frau',
      'Titel/Akad. Grad'                       => 'Dr.',
      'Adressart'                              => 'STR',
      'Straße'                                 => 'Am Haagelspfädchen 14',
      'Postleitzahl'                           => '50999',
      'Ort'                                    => 'Köln',
      'Land'                                   => 'DE',
      'Telefon'                                => '0221/1234567',
      'E-Mail'                                 => 'sabine@mustermann.de',
      'Internet'                               => 'www.mustermann.de',
      'Fax'                                    => '0221/1234568',
      'IBAN 1'                                 => 'DE12500105170648489890',
      'Briefanrede'                            => 'Sehr geehrte Frau Dr. Mustermann',
      'Sprache'                                => 1
    }
  }

  let(:contact2) {
    {
      'Konto'                            => 70001,
      'Name (Adressatentyp Unternehmen)' => 'Meyer GmbH',
      'Adressatentyp'                    => '2'
    }
  }

  let(:contact3) {
    {
      'Konto'                            => 70002,
      'Name (Adressatentyp Unternehmen)' => 'Schulze GmbH',
      'Adressatentyp'                    => '2'
    }
  }

  let(:contact4) {
    {
      'Konto'                            => 70003,
      'Name (Adressatentyp Unternehmen)' => 'Scary Kitten🙀 AG',
      'Adressatentyp'                    => '2'
    }
  }

  let(:export) do
    export = Datev::ContactExport.new(
      'Herkunft'        => 'XY',
      'Exportiert von'  => 'Chief Accounting Officer',
      'Erzeugt am'      => Time.new(2018,3,6,10,25,0, '+02:00'),
      'Berater'         => 1001,
      'Mandant'         => 456,
      'WJ-Beginn'       => Date.new(2018,1,1),
      'Bezeichnung'     => 'Kunden und Lieferanten'
    )

    export << contact1
    export << contact2
    export << contact3
    export << contact4
    export
  end

  describe :to_s do
    subject { export.to_s }

    it 'should export as string' do
      expect(subject).to be_a(String)
      expect(subject.lines.length).to eq(6)
    end

    it "should encode in Windows-1252" do
      expect(subject.encoding).to eq(Encoding::WINDOWS_1252)
    end

    it "should contain header" do
      expect(subject.lines[0]).to include('"EXTF";510')
    end

    it "should contain field names" do
      expect(subject.lines[1]).to include('Konto;Name (Adressatentyp Unternehmen)')
    end

    it "should contain accounts" do
      expect(subject.lines[2]).to include('10000;"";"";"Mustermann"')
      expect(subject.lines[3]).to include('70001;"Meyer GmbH"')
      expect(subject.lines[4]).to include('70002;"Schulze GmbH"')
    end

    it "should replace non-convertible characters by spaces" do
      expect(subject.lines[5]).to include('70003;"Scary Kitten  AG"')
    end
  end

  describe :to_file do
    it 'should export a valid CSV file' do
      Dir.mktmpdir do |dir|
        filename = "#{dir}/EXTF_Stammdaten.csv"
        export.to_file(filename)

        expect {
          CSV.read(filename, Datev::Export::CSV_OPTIONS)
        }.to_not raise_error
      end
    end

    it 'should export a file identically to the given example' do
      Dir.mktmpdir do |dir|
        filename = "#{dir}/EXTF_Stammdaten.csv"
        export.to_file(filename)
        if ENV['CREATE_EXAMPLES']
          export.to_file('examples/EXTF_Stammdaten.csv')
        end

        expect(IO.read(filename)).to eq(IO.read('examples/EXTF_Stammdaten.csv'))
      end
    end
  end
end
