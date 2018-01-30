module Datev
  class Account < Base
    # http://www.datev.de/dnlexom/client/app/index.html#/document/1036228/D103622800011

    # 1
    field 'Konto', :integer, limit: 8, required: true
    # Sachkontennummer (max. 8-stellig).

    # 2
    field 'Kontenbeschriftung', :string, limit: 40
    # Beschriftung des Sachkontos

    # 3
    field 'Sprach-ID', :string, limit: 5
    # Sprach-ID der Kontenbeschriftung
    # de-DE = Deutsch
    # en-GB = Englisch
  end
end
