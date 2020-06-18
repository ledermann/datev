module Datev
  class ContactHeader < Header
    self.default_attributes = {
      'DATEV-Format-KZ' => 'EXTF',
      'Versionsnummer'  => 700,
      'Datenkategorie'  => 16,
      'Formatname'      => 'Debitoren/Kreditoren',
      'Formatversion'   => 4,
      'Erzeugt am'      => Time.now.utc,
      'Sachkontenlänge' => 4
    }
  end
end
