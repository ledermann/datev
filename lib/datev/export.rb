require 'csv'
require 'datev/header'
require 'datev/booking'

module Datev
  class Export
    CSV_OPTIONS = { :col_sep => ';', :encoding => 'windows-1252' }

    DEFAULT_HEADER_ATTRIBUTES = {
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

    def initialize(header_attributes)
      raise ArgumentError.new('Hash required') unless header_attributes.is_a?(Hash)

      @header = Header.new DEFAULT_HEADER_ATTRIBUTES.merge(header_attributes)
      @rows = []
    end

    def <<(attributes)
      @rows << Datev::Booking.new(attributes)
    end

    def to_s
      CSV.generate(CSV_OPTIONS) do |csv|
        write(csv)
      end
    end

    def to_file(filename)
      CSV.open(filename, 'wb', CSV_OPTIONS) do |csv|
        write(csv)
      end
    end

  private

    def write(csv)
      csv << @header.to_a
      csv << Booking.fields.map(&:name)

      @rows.each do |row|
        csv << row.to_a
      end
    end
  end
end
