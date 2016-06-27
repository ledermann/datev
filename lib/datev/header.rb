require 'datev/base'

module Datev
  class Header < Base
    DEFAULT_ATTRIBUTES = {
      'DATEV-Format-KZ' => 'EXTF',
      'Versionsnummer'  => 510,
      'Datenkategorie'  => 21,
      'Formatname'      => 'Buchungsstapel',
      'Formatversion'   => 7,
      'Erzeugt am'      => Time.now.utc,
      'Sachkontenlänge' => 4,
      'Bezeichnung'     => 'Buchungen',
      'Buchungstyp'     => 1,
      'WKZ'             => 'EUR'
    }

    def initialize(attributes={})
      raise ArgumentError.new('Hash required') unless attributes.is_a?(Hash)
      super DEFAULT_ATTRIBUTES.merge(attributes)
    end

    # 1
    field 'DATEV-Format-KZ', :string, :limit => 4
    # vom Datev angegeben
    # EXTF = für Datei-Formate, die von externen Programmen erstellt wurden

    # 2
    field 'Versionsnummer', :integer, :limit => 3
    # entspricht der zugrundeliegenden Versionsnummer des Scnittstellen-Entwicklungsleitfadens

    # 3
    field 'Datenkategorie', :integer, :limit => 2
    # vom Datev angegeben
    # Buchungsstapel = 21

    # 4
    field 'Formatname', :string
    # vom Datev angegeben
    # 'Buchungsstapel'

    # 5
    field 'Formatversion', :integer, :limit => 3
    # vom Datev angegeben
    # Buchungsstapel = 2

    # 6
    field 'Erzeugt am', :date, :format => '%Y%m%d%H%M%S%L'

    # 7
    field 'Importiert', :date
    # Darf nicht gefüllt werden, durch Import gesetzt.

    # 8
    field 'Herkunft', :string, :limit => 2
    # Herkunfts-Kennzeichen
    # Beim Import wird das Herkunfts-Kennzeichen durch „SV“ (= Stapelverarbeitung) ersetzt.

    # 9
    field 'Exportiert von', :string, :limit => 25
    # Benutzername

    # 10
    field 'Importiert von', :string, :limit => 10
    # Darf nicht gefüllt werden, durch Import gesetzt.

    # 11
    field 'Berater', :integer, :limit => 7
    # Beraternummer

    # 12
    field 'Mandant', :integer, :limit => 5
    # Mandantennummer

    # 13
    field 'WJ-Beginn', :date, :format => '%Y%m%d'
    # Wirtschaftsjahresbeginn

    # 14
    field 'Sachkontenlänge', :integer, :limit => 1
    # Kleinste Sachkontenlänge = 4, Grösste Sachkontenlänge = 8

    # 15
    field 'Datum vom', :date, :format => '%Y%m%d'

    # 16
    field 'Datum bis', :date, :format => '%Y%m%d'

    # 17
    field 'Bezeichnung', :string, :limit => 30
    # Bezeichnung des Buchungsstapels

    # 18
    field 'Diktatkürzel', :string, :limit => 2
    # Diktatkürzel Beispiel MM = Max Mustermann

    # 19
    field 'Buchungstyp', :integer, :limit => 1
    # 1 = Finanzbuchhaltung, 2 = Jahresabschluss

    # 20
    field 'Rechnungslegungszweck' , :integer, :limit => 2
    # 0 oder leer = Rechnungslegungszweckunabhängig

    # 21
    field 'reserviert', :integer

    # 22
    field 'WKZ', :string, :limit => 3
    # Währungskennzeichen

    # 23 - 26
    field 'reserviert 2', :string
    field 'reserviert 3', :string
    field 'reserviert 4', :string
    field 'reserviert 5', :string
  end
end
