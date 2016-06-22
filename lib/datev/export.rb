require 'csv'
require 'datev/header'
require 'datev/booking'

module Datev
  class Export
    CSV_OPTIONS = { :col_sep => ';' }

    DEFAULT_HEADER_ATTRIBUTES = {
      'DATEV-Format-KZ' => 'EXTF',
      'Versionsnummer'  => 510,
      'Datenkategorie'  => 21,
      'Formatname'      => 'Buchungsstapel',
      'Formatversion'   => 7,
      'Erzeugt am'      => Time.now,
      'Sachkontenlänge' => 4,
      'Bezeichnung'     => 'Buchungen',
      'Buchungstyp'     => 1,
      'WKZ'             => 'EUR'
    }

    def initialize(header_attributes)
      @header = Header.new DEFAULT_HEADER_ATTRIBUTES.merge(header_attributes)
      @rows = []
    end

    def <<(booking)
      raise ArgumentError.new('Param must be a Datev::Booking instance') unless booking.is_a?(Booking)

      @rows << booking
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
