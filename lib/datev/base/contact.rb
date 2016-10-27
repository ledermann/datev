module Datev
  class Contact < Base
    def self.bank_account(number)
      field "Bankleitzahl #{number}", :string, :limit => 8

      field "Bankbezeichnung #{number}", :string, :limit => 30

      field "Bankkonto-Nummer #{number}", :string, :limit => 10

      field "Länderkennzeichen #{number}", :string, :limit => 2
      # ISO-Code beachten (siehe Dok.-Nr. 1080169)

      field "IBAN #{number}", :string, :limit => 34

      field "Leerfeld #{number}", :string, :limit => 1

      field "SWIFT-Code #{number}", :string, :limit => 11
      # Beachten Sie, dass für Zahlung und Lastschriften bis zur Installation der Programm-DVD DATEV pro 8.3 (Januar 2015) BLZ und/oder BIC noch erforderlich sind.

      field "Abw. Kontoinhaber #{number}", :string, :limit => 70

      field "Kennz. Haupt-Bankverb. #{number}", :boolean
      # Kennzeichnung als Haupt-Bankverbindung
      # 1 = Ja
      # 0 = Nein
      # Nur eine Bankverbindung eines Debitoren oder Kreditoren kann als Haupt-Bankverbindung gekennzeichnet werden.

      field "Bankverb. #{number} Gültig von", :date, :format => '%d%m%Y'
      field "Bankverb. #{number} Gültig bis", :date, :format => '%d%m%Y'
    end

    # http://www.datev.de/dnlexom/client/app/index.html#/document/1036228/D103622800012

    # 1
    field 'Konto', :integer, :limit => 9, :required => true
    # Personen-Kontonummer (abhängig von der Information im Header)
    # Sachkontennummernlänge + 1 = Personenkontenlänge

    # 2
    field 'Name (Adressatentyp Unternehmen)', :string, :limit => 50
    # Beim Import werden die Felder in der Datenbank gefüllt, auch wenn sie nicht dem Adressatentyp aus Feld 7 entsprechen. Das kann zu ungewollten Effekten im Programm führen. Bitte übergeben Sie nur die zum Adressatentyp passenden Felder.

    # 3
    field 'Unternehmensgegenstand', :string, :limit => 50

    # 4
    field 'Name (Adressatentyp natürl. Person)', :string, :limit => 30

    # 5
    field 'Vorname (Adressatentyp natürl. Person)', :string, :limit => 30

    # 6
    field 'Name (Adressatentyp keine Angabe)', :string, :limit => 50

    # 7
    field 'Adressatentyp', :string, :limit => 1
    # 0 = keine Angabe
    # 1 = natürliche Person
    # 2 = Unternehmen
    # Standardwert = Unternehmen

    # 8
    field 'Kurzbezeichnung', :string, :limit => 15

    # 9
    field 'EU-Land', :string, :limit => 2
    # Die USt-IdNr. besteht aus
    # 2-stelligen Länderkürzel
    # (siehe Dok.-Nr. 1080169; Ausnahme Griechenland: Das Länderkürzel lautet EL)
    # 13-stelliger USt-IdNr.
    # Beachten Sie bitte, dass kein Leerzeichen zwischen diesen beiden Eingabewerten sein darf.

    # 10
    field 'EU-USt-IdNr.', :string, :limit => 13

    # 11
    field 'Anrede', :string, :limit => 30

    # 12
    field 'Titel/Akad. Grad', :string, :limit => 25
    # Nur bei Adressatentyp "natürliche Person" relevant.
    # Wird der Titel/Akad.Grad bei einem Adressatentyp "Unternehmen" übergeben, wird der Wert in den Datenbestand übernommen, ist aber an der Oberfläche nicht sichtbar.

    # 13
    field 'Adelstitel', :string, :limit => 15
    # Nur bei Adressatentyp "natürliche Person" relevant.
    # Wird der Adelstitel bei einem Adressatentyp "Unternehmen" übergeben, wird der Wert in den Datenbestand übernommen, ist aber an der Oberfläche nicht sichtbar.

    # 14
    field 'Namensvorsatz', :string, :limit => 14
    # Nur bei Adressatentyp "natürliche Person" relevant.
    # Wird der Namensvorsatz bei einem Adressatentyp "Unternehmen" übergeben, wird der Wert in den Datenbestand übernommen, ist aber an der Oberfläche nicht sichtbar.

    # 15
    field 'Adressart', :string, :limit => 3
    # STR = Straße
    # PF = Postfach
    # GK = Großkunde
    # Wird die Adressart nicht übergeben, wird sie automatisch in Abhängigkeit zu den übergebenen Feldern (Straße oder Postfach) gesetzt.

    # 16
    field 'Straße', :string, :limit => 36
    # Wird sowohl eine Straße als auch ein Postfach übergeben, werden beide Werte in den Datenbestand übernommen; auf der Visitenkarte in den Debitoren-/Kreditoren-Stammdaten wird die Postfachadresse angezeigt.

    #17
    field 'Postfach', :string, :limit => 10

    # 18
    field 'Postleitzahl', :string, :limit => 10

    # 19
    field 'Ort', :string, :limit => 30

    # 20
    field 'Land', :string, :limit => 2
    # ISO-Code beachten! (Dok.-Nr. 1080169)

    # 21
    field 'Versandzusatz', :string, :limit => 50

    # 22
    field 'Adresszusatz', :string, :limit => 36
    # Beispiel: z. Hd. Herrn Mustermann

    # 23
    field 'Abweichende Anrede', :string, :limit => 30
    # Es kann ein beliebiger individueller Text verwendet werden.

    # 24
    field 'Abw. Zustellbezeichnung 1', :string, :limit => 50

    # 25
    field 'Abw. Zustellbezeichnung 2', :string, :limit => 36

    # 26
    field 'Kennz. Korrespondenzadresse', :boolean
    # 1= Kennzeichnung Korrespondenzadresse

    # 27
    field 'Adresse Gültig von', :date, :format => '%d%m%Y'

    # 28
    field 'Adresse Gültig bis', :date, :format => '%d%m%Y'

    # 29
    field 'Telefon', :string, :limit => 60
    # Standard-Telefonnummer

    # 30
    field 'Bemerkung (Telefon)', :string, :limit => 40

    # 31
    field 'Telefon Geschäftsleitung', :string, :limit => 60
    # Geschäftsleitungs-Telefonnummer

    # 32
    field 'Bemerkung (Telefon GL)', :string, :limit => 40

    # 33
    field 'E-Mail', :string, :limit => 60

    # 34
    field 'Bemerkung (E-Mail)', :string, :limit => 40

    # 35
    field 'Internet', :string, :limit => 60

    # 36
    field 'Bemerkung (Internet)', :string, :limit => 40

    # 37
    field 'Fax', :string, :limit => 60

    # 38
    field 'Bemerkung (Fax)', :string, :limit => 40

    # 39
    field 'Sonstige', :string, :limit => 60

    # 40
    field 'Bemerkung (Sonstige)', :string, :limit => 40

    # 41 bis 95
    (1..5).each do |number|
      self.bank_account(number)
    end

    # 96
    field 'Leerfeld 11', :integer, :limit => 3

    # 97
    field 'Briefanrede', :string, :limit => 100

    # 98
    field 'Grußformel', :string, :limit => 50

    # 99
    field 'Kundennummer', :string, :limit => 15
    # Kann nicht geändert werden, wenn zentralisierte Geschäftspartner verwendet werden.

    # 100
    field 'Steuernummer', :string, :limit => 20

    # 101
    field 'Sprache', :integer, :limit => 2
    # 1 = Deutsch
    # 4 = Französisch
    # 5 = Englisch
    # 10 = Spanisch
    # 19 = Italienisch

    # 102
    field 'Ansprechpartner', :string, :limit => 40

    # 103
    field 'Vertreter', :string, :limit => 40

    # 104
    field 'Sachbearbeiter', :string, :limit => 40

    # 105
    field 'Diverse-Konto', :boolean
    # 0 = Nein
    # 1 = Ja

    # 106
    field 'Ausgabeziel', :integer, :limit => 1
    # 1 = Druck 
    # 2 = Telefax
    # 3 = E-Mail

    # 107
    field 'Währungssteuerung', :integer, :limit => 1
    # 0 = Zahlungen in Eingabewährung
    # 2 = Ausgabe in EUR

    # 108
    field 'Kreditlimit (Debitor)', :integer, :limit => 10
    # Nur für Debitoren gültig
    # Beispiel: 1.123.123.123

    # 109
    field 'Zahlungsbedingung', :integer, :limit => 3
    # Eine gespeicherte Zahlungsbedingung kann hier einem Geschäftspartner zugeordnet werden.

    # 110
    field 'Fälligkeit in Tagen (Debitor)', :integer, :limit => 3
    # Nur für Debitoren gültig

    # 111
    field 'Skonto in Prozent (Debitor)', :decimal, :precision => 4, :scale => 2
    # Nur für Debitoren gültig
    # Beispiel: 12,12

    # 112 bis 120
    (1..5).each do |number|
      if 3 == number
        field "Kreditoren-Ziel #{number} Brutto (Tage)", :integer, :limit => 3
      else
        field "Kreditoren-Ziel #{number} (Tage)", :integer, :limit => 2
        # Nur für Kreditoren gültig

        field "Kreditoren-Skonto #{number} (%)", :decimal, :precision => 4, :scale => 2
        # Nur für Kreditoren gültig
        # Beispiel: 12,12
      end
    end

    # 121
    field 'Mahnung', :integer, :limit => 1
    # 0 = Keine Angaben
    # 1 = 1. Mahnung
    # 2 = 2. Mahnung
    # 3 = 1. + 2. Mahnung
    # 4 = 3. Mahnung
    # 5 = (nicht vergeben)
    # 6 = 2. + 3. Mahnung
    # 7 = 1., 2. + 3. Mahnung
    # 9 = keine Mahnung

    # 122
    field 'Kontoauszug', :integer, :limit => 1
    # 1 = Kontoauszug für alle Posten
    # 2 = Auszug nur dann, wenn ein Posten mahnfähig ist
    # 3 = Auszug für alle mahnfälligen Posten
    # 9 = kein Kontoauszug

    field 'Mahntext', :integer, :limit => 1
    # Leer = keinen Mahntext ausgewählt
    # 1 = Textgruppe 1
    # ...
    # 9 = Textgruppe 9

    # 124
    field 'Mahntext 2', :integer, :limit => 1
    # Leer = keinen Mahntext ausgewählt
    # 1 = Textgruppe 1
    # ...
    # 9 = Textgruppe 9

    # 125
    field 'Mahntext 3', :integer, :limit => 1
    # Leer = keinen Mahntext ausgewählt
    # 1 = Textgruppe 1
    # ...
    # 9 = Textgruppe 9

    # 126
    field 'Kontoauszugstext', :integer, :limit => 1
    # Leer = kein Kontoauszugstext ausgewählt
    # 1 = Kontoauszugstext 1
    # ...
    # 8 = Kontoauszugstext 8
    # 9 = Kein Kontoauszugstext

    # 127
    field 'Mahnlimit Betrag', :decimal, :precision => 7, :scale => 2
    # Beispiel: 12.123,12

    # 128
    field 'Mahnlimit %', :decimal, :precision => 4, :scale => 2
    # Beispiel: 12,12

    # 129
    field 'Zinsberechnung', :integer, :limit => 1
    # 0 = MPD-Schlüsselung gilt
    # 1 = Fester Zinssatz
    # 2 = Zinssatz über Staffel
    # 9 = Keine Berechnung für diesen Debitor

    # 130 - 132
    (1..3).each do |number|
      field "Mahnzinssatz #{number}", :decimal, :precision => 4, :scale => 2
      # Beispiel: 12,12
    end

    # 133
    field 'Lastschrift', :string, :limit => 1
    # Leer bzw. 0 = keine Angaben, es gilt die MPD-Schlüsselung
    # 1 = Einzellastschrift mit einer Rechnung
    # 2 = Einzellastschrift mit mehreren Rechnungen
    # 3 = Sammellastschrift mit einer Rechnung
    # 4 = Sammellastschrift mit mehreren Rechnungen
    # 5 = Datenträgeraustausch mit einer Rechnung
    # 6 = Datenträgeraustausch mit mehreren Rechnungen
    # 7 = SEPA-Lastschrift mit einer Rechnung
    # 8 = SEPA-Lastschrift mit mehreren Rechnungen
    # 9 = kein Lastschriftverfahren bei diesem Debitor

    # 134
    field 'Verfahren', :string, :limit => 1
    # 0 = Einzugsermächtigung
    # 1 = Abbuchungsverfahren

    # 135
    field 'Mandantenbank', :integer, :limit => 4
    # Zuordnung der gespeicherten Mandantenbank, die für das Lastschriftverfahren verwendet werden soll.

    # 136
    field 'Zahlungsträger', :string, :limit => 1
    # Leer bzw. 0 = keine Angaben, es gilt die MPD-Schlüsselung
    # 1 = Einzelüberweisung mit einer Rechnung
    # 2 = Einzelüberweisung mit mehreren Rechnungen
    # 3 = Sammelüberweisung mit einer Rechnung
    # 4 = Sammelüberweisung mit mehreren Rechnungen
    # 5 = Einzelscheck
    # 6 = Sammelscheck
    # 7 = SEPA-Überweisung mit einer Rechnung
    # 8 = SEPA-Überweisung mit mehreren Rechnungen
    # 9 = keine Überweisungen, Schecks

    # 137 bis 151
    (1..15).each do |number|
      field "Indiv. Feld #{number}", :string, :limit => 40

      # 11 bis 15 wird derzeit nicht übernommen
    end

    # 152
    field 'Abweichende Anrede (Rechnungsadresse)', :string, :limit => 30
    # Es kann ein beliebiger individueller Text verwendet werden.

    # 153
    field 'Adressart (Rechnungsadresse)', :string, :limit => 3
    # STR = Straße 
    # PF = Postfach
    # GK = Großkunde
    # Wird die Adressart nicht übergeben, wird sie automatisch in Abhängigkeit zu den übergebenen Feldern (Straße oder Postfach) gesetzt.

    # 154
    field 'Straße (Rechnungsadresse)', :string, :limit => 36
    # Wird sowohl eine Straße als auch ein Postfach übergeben, werden beide Werte in den Datenbestand übernommen; auf der Visitenkarte in den Debitoren-/Kreditoren-Stammdaten wird die Postfachadresse angezeigt.

    # 155
    field 'Postfach (Rechnungsadresse)', :string, :limit => 10

    # 156
    field 'Postleitzahl (Rechnungsadresse)', :string, :limit => 10

    # 157
    field 'Ort (Rechnungsadresse)', :string, :limit => 30

    # 158
    field 'Land (Rechnungsadresse)', :string, :limit => 2
    # ISO-Code beachten (siehe Dok.-Nr. 1080169)

    # 159
    field 'Versandzusatz (Rechnungsadresse)', :string, :limit => 50

    # 160
    field 'Adresszusatz (Rechnungsadresse)', :string, :limit => 36
    # Beispiel: z. Hd. Herrn Mustermann

    # 161
    field 'Abw. Zustellbezeichnung 1 (Rechnungsadresse)', :string, :limit => 50

    # 162
    field 'Abw. Zustellbezeichnung 2 (Rechnungsadresse)', :string, :limit => 36

    # 163
    field 'Adresse Gültig von (Rechnungsadresse)', :date, :format => '%d%m%Y'

    # 164
    field 'Adresse Gültig bis (Rechnungsadresse)', :date, :format => '%d%m%Y'

    # 165 bis 219
    (6..10).each do |number|
      bank_account(number)
    end

    # 220
    field 'Nummer Fremdsystem', :string, :limit => 15
    # Achtung: Wird bei Verwendung zentralisierter Geschäftspartner von DATEV überschrieben.

    # 221
    field 'Insolvent', :boolean
    # 0 = Nein
    # 1 = Ja

    # 222 bis 231
    (1..10).each do |number|
      field "SEPA-Mandatsreferenz #{number}", :string, :limit => 35
      # Sie können im Feld Mandatsreferenz dem Geschäftspartner je Bank eine Mandatsreferenz eintragen. Für eine korrekte Verwendung muss in der SEPA-Mandatsverwaltung die Mandatsreferenz für den Lastschriftteilnehmer vorhanden sein.
    end

    # 232
    field 'Verknüpftes OPOS-Konto', :integer, :limit => 9
    # Sie können für den Geschäftspartner das korrespondierende Konto (im Kreditorenbereich) erfassen, wenn es sich bei dem Geschäftspartner sowohl um einen Kunden als auch um einen Lieferanten handelt.

    # --- Erweiterungen zur Jahreswechselversion 2015/2016

    # 233
    field 'Mahnsperre bis', :date, :format => '%d%m%Y'

    # 234
    field 'Lastschriftsperre bis', :date, :format => '%d%m%Y'

    # 235
    field 'Zahlungssperre bis', :date, :format => '%d%m%Y'

    # 236
    field 'Gebührenberechnung', :integer, :limit => 1
    # 0 = MPD-Schlüsselung gilt
    # 1 = Mahngebühr berechnen
    # 9 = Keine Berechnung für diesen Debitor

    # 237 bis 239
    (1..3).each do |number|
      field "Mahngebühr #{number}", :decimal, :precision => 4, :scale => 2
      # Beispiel: 12,12
    end

    # 240
    field 'Pauschalberechnung', :integer, :limit => 1
    # 0 = MPD-Schlüsselung gilt
    # 1 = Verzugspauschale berechnen
    # 9 = Keine Berechnung für diesen Debitor

    # 241 bis 243
    (1..3).each do |number|
      field "Verzugspauschale #{number}", :decimal, :precision => 5, :scale => 2
      # Beispiel: 12,12
    end
  end
end
