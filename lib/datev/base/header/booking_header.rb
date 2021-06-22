module Datev
  class BookingHeader < Header
    self.default_attributes = proc do
      {
        'DATEV-Format-KZ' => 'EXTF',
        'Versionsnummer'  => 700,
        'Datenkategorie'  => 21,
        'Formatname'      => 'Buchungsstapel',
        'Formatversion'   => 9,
        'Erzeugt am'      => Time.now.utc,
        'Sachkontenlänge' => 4,
        'Bezeichnung'     => 'Buchungen',
        'Buchungstyp'     => 1,
        'WKZ'             => 'EUR'
      }
    end
  end
end
