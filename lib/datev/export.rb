require 'csv'
require 'datev/base/header'

module Datev
  class Export
    CSV_OPTIONS = { :col_sep => ';', :encoding => 'windows-1252' }

    class << self
      attr_accessor :header_class, :row_class
    end

    def initialize(header_attributes)
      @header = self.class.header_class.new(header_attributes)
      @rows = []
    end

    def <<(attributes)
      @rows << self.class.row_class.new(attributes)
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
      csv << self.class.row_class.fields.map(&:name)

      @rows.each do |row|
        csv << row.output(@header)
      end
    end
  end
end
