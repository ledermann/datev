module Datev
  class BookingHeader < Header
    self.default_attributes = {
      'DATEV-Format-KZ' => 'EXTF',
      'Versionsnummer'  => 820,
      'Datenkategorie'  => 21,
      'Formatname'      => 'Buchungsstapel',
      'Formatversion'   => 7,
      'Erzeugt am'      => Time.now.utc,
      'Sachkontenlänge' => 4,
      'Bezeichnung'     => 'Buchungen',
      'Buchungstyp'     => 1,
      'WKZ'             => 'EUR'
    }
  end
end
