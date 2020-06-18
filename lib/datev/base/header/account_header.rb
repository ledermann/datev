module Datev
  class AccountHeader < Header
    self.default_attributes = {
      'DATEV-Format-KZ' => 'EXTF',
      'Versionsnummer'  => 700,
      'Datenkategorie'  => 20,
      'Formatname'      => 'Kontenbeschriftungen',
      'Formatversion'   => 2,
      'Erzeugt am'      => Time.now.utc,
      'Sachkontenlänge' => 4,
      'Bezeichnung'     => 'Kontenbeschriftungen'
    }
  end
end
