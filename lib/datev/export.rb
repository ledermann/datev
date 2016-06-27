require 'csv'
require 'datev/header'
require 'datev/booking'

module Datev
  class Export
    CSV_OPTIONS = { :col_sep => ';', :encoding => 'windows-1252' }

    def initialize(header_attributes)
      @header = Header.new header_attributes
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
      csv << @header.output
      csv << Booking.fields.map(&:name)

      @rows.each do |row|
        csv << row.output(@header)
      end
    end
  end
end
