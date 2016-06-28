require 'datev/base'

module Datev
  class Booking < Base
    # http://www.datev.de/dnlexom/client/app/index.html#/document/1036228/D103622800010

    # 1
    field 'Umsatz (ohne Soll/Haben-Kz)', :decimal, :precision => 12, :scale => 2, :required => true
    # Beispiel: 1234567890,12
    # Muss immer ein positiver Wert sein

    # 2
    field 'Soll/Haben-Kennzeichen', :string, :limit => 1, :required => true
    # Die Soll-/Haben-Kennzeichnung des Umsatzes bezieht sich auf das Konto, das im Feld Konto angegeben wird:
    # S = Soll
    # H = Haben

    # 3
    field 'WKZ Umsatz', :string, :limit => 3
    # Dreistelliger ISO-Code der Währung (Dok.-Nr. 1080170); gibt an, welche Währung dem Betrag zugrunde liegt.
    # Wenn kein Wert angegeben ist, wird das WKZ aus dem Header übernommen.

    # 4
    field 'Kurs', :decimal, :precision => 10, :scale => 6
    # Der Fremdwährungskurs bestimmt, wie der angegebene Umsatz, der in Fremdwährung übergeben wird, in die Basiswährung umzurechnen ist, wenn es sich um ein Nicht-EWU-Land handelt.
    # Beispiel: 1123,123456
    # Achtung: Der Wert 0 ist unzulässig.

    # 5
    field 'Basisumsatz', :decimal, :precision => 12, :scale => 2
    # Wenn das Feld Basisumsatz verwendet wird, muss auch das Feld WKZ Basisumsatz gefüllt werden.
    # Beispiel: 1123123123,12

    # 6
    field 'WKZ Basisumsatz', :string, :limit => 3
    # Währungskennzeichen der hinterlegten Basiswährung. Wenn das Feld WKZ Basisumsatz verwendet wird, muss auch das Feld Basisumsatz verwendet werden.
    # ISO-Code beachten (siehe Dok.-Nr.1080170)

    # 7
    field 'Konto', :integer, :limit => 9, :required => true do
    # Sach- oder Personen-Kontonummer
    # Darf max. 8- bzw. max. 9-stellig sein (abhängig von der Information im Header)
    # Die Personenkontenlänge darf nur 1 Stelle länger sein als die definierte Sachkontennummernlänge.

      def output(value, context)
        length = context['Sachkontenlänge']
        value.to_s.rjust(length, '0')
      end
    end

    # 8
    field 'Gegenkonto (ohne BU-Schlüssel)', :integer, :limit => 9, :required => true do
    # Sach- oder Personen-Kontonummer
    # Darf max. 8- bzw. max. 9-stellig sein (abhängig von der Information im Header)
    # Die Personenkontenlänge darf nur 1 Stelle länger sein als die definierte Sachkontennummernlänge.

      def output(value, context)
        length = context['Sachkontenlänge']
        value.to_s.rjust(length, '0')
      end
    end

    # 9
    field 'BU-Schlüssel', :string, :limit => 2
    # Steuerschlüssel und/oder Berichtigungsschlüssel

    # 10
    field 'Belegdatum', :date, :format => '%d%m', :required => true
    # Achtung: Auch bei individueller Feldformatierung mit vierstelliger Jahreszahl wird immer in das aktuelle Wirtschaftsjahr importiert, wenn Tag und Monat des Datums im bebuchbaren Zeitraum liegen, da die Jahreszahl nicht berücksichtigt wird.

    # 11
    field 'Belegfeld 1', :string, :limit => 12
    # Rechnungs-/Belegnummer
    # Das Belegfeld 1 ist der "Schlüssel" für die Verwaltung von Offenen Posten.
    # Bei einer Zahlung oder Gutschrift erfolgt nur dann ein OP-Ausgleich, wenn die Belegnummer mit dem Belegfeld 1 identisch ist.

    # 12
    field 'Belegfeld 2', :string, :limit => 12
    # Belegnummer oder OPOS-Verarbeitungsinformationen

    # 13
    field 'Skonto', :decimal, :precision => 10, :scale => 2
    # Skonto-Betrag/-Abzug
    # Nur bei Zahlungen zulässig.
    # Beispiel 12123123,12
    # Achtung: Der Wert 0 ist unzulässig.

    # 14
    field 'Buchungstext', :string, :limit => 60

    # 15
    field 'Postensperre', :boolean
    # Mahn-/Zahl-Sperre
    # Die Rechnung kann aus dem Mahnwesen / Zahlungsvorschlag ausgeschlossen werden.
    # true = Postensperre
    # false/keine Angabe = keine Sperre
    # Nur in Verbindung mit einer Rechnungsbuchung und Personenkonto (OPOS) relevant.

    # 16
    field 'Diverse Adressnummer', :string, :limit => 9
    # Adressnummer einer diversen Adresse
    # Nur in Verbindung mit OPOS relevant.

    # 17
    field 'Geschäftspartnerbank', :integer, :limit => 3
    # Wenn für eine Lastschrift oder Überweisung eine bestimmte Bank des Geschäftspartners genutzt werden soll.
    # Nur in Verbindung mit OPOS relevant.

    # 18
    field 'Sachverhalt', :integer, :limit => 2
    # Der Sachverhalt wird in Rechnungswesen pro verwendet, um Buchungen/Posten als Mahnzins/Mahngebühr zu identifizieren.
    # Für diese Posten werden z. B. beim Erstellen von Mahnungen keine Mahnzinsen berechnet.
    # 31 = Mahnzins
    # 40 = Mahngebühr
    # Nur in Verbindung mit OPOS relevant.

    # 19
    field 'Zinssperre', :boolean
    # Hier kann eine Zinssperre übergeben werden; dadurch werden für diesen Posten bei Erstellung einer Mahnung keine Mahnzinsen ermittelt.
    # Nur in Verbindung mit OPOS relevant.
    # keine Angabe und 0 = keine Sperre
    # 1 = Zinssperre

    # 20
    field 'Beleglink', :string, :limit => 210
    # Link auf den Buchungsbeleg, der digital in einem Dokumenten-Management-System (z. B. DATEV Dokumentenablage, DATEV DMS classic) abgelegt wurde.
    # Beispiel für eine Beleg-ID eines Belegs aus DATEV Unternehmen online:
    # CB6A8F8F-099A-B3A9-2BAA-0CB64E299BA
    # (32 von 36 möglichen Zeichen)

    # 21 bis 36
    (1..8).each do |number|
      field "Beleginfo – Art #{number}", :string, :limit => 20
      field "Beleginfo – Inhalt #{number}", :string, :limit => 210
    end
    # Bei einem ASCII-Format, das aus einem DATEV pro-Rechnungswesen-Programm erstellt wurde, können diese Felder Informationen aus einem Beleg (z. B. einem elektronischen Kontoumsatz) enthalten.
    # Wenn die Feldlänge eines Beleginfo-Inhalts-Felds überschritten wird, wird die Information im nächsten Beleginfo-Feld weitergeführt.
    # Wichtiger Hinweis
    # Eine Beleginfo besteht immer aus den Bestandteilen Beleginfo-Art und Beleginfo-Inhalt. Wenn Sie die Beleginfo nutzen möchten, befüllen Sie immer beide Felder.
    # Beispiel:
    # Beleginfo-Art:
    # Kontoumsätze der jeweiligen Bank
    # Beleginfo-Inhalt:
    # Buchungsspezifische Inhalte zu den oben genannten Informationsarten

    # 37
    field 'KOST1 – Kostenstelle', :string, :limit => 8
    # Über KOST1 erfolgt die Zuordnung des Geschäftsvorfalls für die anschließende Kostenrechnung.

    # 38
    field 'KOST2 – Kostenstelle', :string, :limit => 8
    # Über KOST2 erfolgt die Zuordnung des Geschäftsvorfalls für die anschließende Kostenrechnung.

    # 39
    field 'Kost Menge', :decimal, :precision => 11, :scale => 2
    # Im KOST-Mengenfeld wird die Wertgabe zu einer bestimmten Bezugsgröße für eine Kostenstelle erfasst. Diese Bezugsgröße kann z. B. kg, g, cm, m, % sein. Die Bezugsgröße ist definiert in den Kostenrechnungs-Stammdaten.
    # Beispiel: 123123123,12

    # 40
    field 'EU-Land u. USt-IdNr.', :string, :limit => 15
    # Die USt-IdNr. besteht aus:
    # 2-stelligen Länderkürzel (siehe Dok.-Nr. 1080169; Ausnahme Griechenland: Das Länderkürzel lautet EL)
    # 13-stelliger USt-IdNr.

    # 41
    field 'EU-Steuersatz', :decimal, :precision => 4, :scale => 2
    # Nur für entsprechende EU-Buchungen:
    # Der im EU-Bestimmungsland gültige Steuersatz.
    # Beispiel: 12,12

    # 42
    field 'Abw. Versteuerungsart', :string, :limit => 1
    # Für Buchungen, die in einer von der Mandantenstammdaten-Schlüsselung abweichenden Umsatzsteuerart verarbeitet werden sollen, kann die abweichende Versteuerungsart im Buchungssatz übergeben werden:
    # I = Ist-Versteuerung
    # K = keine Umsatzsteuerrechnung
    # P = Pauschalierung (z. B. für Land- und Forstwirtschaft)
    # S = Soll-Versteuerung

    # 43
    field 'Sachverhalt L+L', :integer, :limit => 3
    # Sachverhalte gem. § 13b Abs. 1 Satz 1 Nrn. 1.ff UStG
    # Achtung: Der Wert 0 ist unzulässig.
    # (siehe Dok.-Nr. 1034915)

    # 44
    field 'Funktionsergänzung L+L', :integer, :limit => 3
    # Steuersatz/Funktion zum L+L-Sachverhalt
    # Achtung: Der Wert 0 ist unzulässig.
    # (siehe Dok.-Nr. 1034915)

    # 45
    field 'BU 49 Hauptfunktionstyp', :integer, :limit => 1
    # Bei Verwendung des BU-Schlüssels 49 für "andere Steuersätze" muss der steuerliche Sachverhalt mitgegeben werden.

    # 46
    field 'BU 49 Hauptfunktionsnummer', :integer, :limit => 2

    # 47
    field 'BU 49 Funktionsergänzung', :integer, :limit => 3

    # 48 bis 87
    (1..20).each do |number|
      field "Zusatzinformation – Inhalt #{number}", :string, :limit => 210
      field "Zusatzinformation – Art #{number}", :string, :limit => 20
    end
    # Zusatzinformationen, die zu Buchungssätzen erfasst werden können.
    # Diese Zusatzinformationen besitzen den Charakter eines Notizzettels und können frei erfasst werden.
    # Wichtiger Hinweis
    # Eine Zusatzinformation besteht immer aus den Bestandteilen Informationsart und Informationsinhalt. Wenn Sie die Zusatzinformation nutzen möchten, füllen Sie immer beide Felder.
    # Beispiel:
    # Informationsart, z. B. Filiale oder Mengengrößen (qm)
    # Informationsinhalt: Buchungsspezifische Inhalte zu den oben genannten Informationsarten.

    # 88
    field 'Stück', :integer, :limit => 8
    # Wirkt sich nur bei Sachverhalt mit SKR14 Land- und Forstwirtschaft aus, für andere SKR werden die Felder beim Import/Export überlesen bzw. leer exportiert.

    # 89
    field 'Gewicht', :decimal, :limit => 10, :scale => 2

    # 90
    field 'Zahlweise', :integer, :limit => 2
    # OPOS-Informationen kommunal
    # 1 = Lastschrift
    # 2 = Mahnung
    # 3 = Zahlung

    # 91
    field 'Forderungsart', :string, :limit => 10
    # OPOS-Informationen kommunal

    # 92
    field 'Veranlagungsjahr', :date, :format => '%Y'
    # OPOS-Informationen kommunal

    # 93
    field 'Zugeordnete Fälligkeit', :date, :format => '%d%m%Y'
    # OPOS-Informationen kommunal

    # 94
    field 'Skontotyp', :integer, :limit => 1
    # 1 = Einkauf von Waren
    # 2 = Erwerb von Roh-Hilfs- und Betriebsstoffen

    # 95
    field 'Auftragsnummer', :string, :limit => 30
    # Allgemeine Bezeichnung, des Auftrags/Projekts

    # 96
    field 'Buchungstyp', :string, :limit => 2
    # AA = Angeforderte Anzahlung/Abschlagsrechnung
    # AG = Erhaltene Anzahlung (Geldeingang)
    # AV = Erhaltene Anzahlung (Verbindlichkeit)
    # SR = Schlussrechnung
    # SU = Schlussrechnung (Umbuchung)
    # SG = Schlussrechnung (Geldeingang)
    # SO = Sonstige

    # 97
    field 'USt-Schlüssel (Anzahlungen)', :integer, :limit => 2
    # USt-Schlüssel der späteren Schlussrechnung

    # 98
    field 'EU-Mitgliedstaat (Anzahlungen)', :string, :limit => 2
    # EU-Mitgliedstaat der späteren Schlussrechnung
    # (siehe Dok.-Nr. 1080169)

    # 99
    field 'Sachverhalt L+L (Anzahlungen)', :integer, :limit => 3
    # L+L-Sachverhalt der späteren Schlussrechnung
    # Sachverhalte gem. § 13b Abs. 1 Satz 1 Nrn. 1.-5. UStG
    # Achtung: Der Wert 0 ist unzulässig.

    # 100
    field 'EU-Steuersatz (Anzahlungen)', :decimal, :precision => 4, :scale => 2
    # EU-Steuersatz der späteren Schlussrechnung
    # Nur für entsprechende EU-Buchungen: Der im EU-Bestimmungsland gültige Steuersatz.
    # Beispiel: 12,12

    # 101
    field 'Erlöskonto (Anzahlungen)', :integer, :limit => 9
    # Erlöskonto der späteren Schlussrechnung

    # 102
    field 'Herkunft-Kz', :string, :limit => 2
    # Wird beim Import durch SV (Stapelverarbeitung) ersetzt.

    # 103
    field 'Leerfeld', :string, :limit => 36
    # Wird von DATEV verwendet.

    # 104
    field 'KOST-Datum', :date, :format => '%d%m%Y'
    # Format TTMMJJJJ

    # 105
    field 'SEPA-Mandatsreferenz', :string, :limit => 35
    # Vom Zahlungsempfänger individuell vergebenes Kennzeichen eines Mandats (z. B. Rechnungs- oder Kundennummer).

    # 106
    field 'Skontosperre', :boolean
    # 0 = keine Skontosperre
    # 1 = Skontosperre

    # 107
    field 'Gesellschaftername', :string, :limit => 76

    # 108
    field 'Beteiligtennummer', :integer, :limit => 4

    # 109
    field 'Identifikationsnummer', :string, :limit => 11

    # 110
    field 'Zeichnernummer', :string, :limit => 20

    # 111
    field 'Postensperre bis', :date, :format => '%d%m%Y'

    # 112
    field 'Bezeichnung', :string, :limit => 30
    # SoBil-Sachverhalt

    # 113
    field 'Kennzeichen', :integer, :limit => 2
    # SoBil-Buchung

    # 114
    field 'Festschreibung', :boolean
    # leer = nicht definiert; wird ab Jahreswechselversion 2016/2017 automatisch festgeschrieben
    # 0 = keine Festschreibung
    # 1 = Festschreibung
    # Hat ein Buchungssatz in diesem Feld den Inhalt 1, so wird der gesamte Stapel nach dem Import festgeschrieben.
    # Ab Jahreswechselversion 2016/2017 gilt das auch bei Inhalt = leer.

    # 115
    field 'Leistungsdatum', :date, :format => '%d%m%Y'

    # 116
    field 'Datum Zuord.', :date, :format => '%d%m%Y'
    # Steuerperiode
  end
end
