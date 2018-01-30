module Datev
  class Export
    CSV_OPTIONS = { col_sep: ';', encoding: 'windows-1252' }

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
      string = to_csv_line(@header.output) <<
               to_csv_line(self.class.row_class.fields.map(&:name))

      @rows.each do |row|
        string << to_csv_line(row.output(@header))
      end

      string.encode(CSV_OPTIONS[:encoding], invalid: :replace, undef: :replace, replace: ' ')
    end

    def to_file(filename)
      File.open(filename, 'wb') do |file|
        file.write(to_s)
      end
    end

  private

    def to_csv_line(data)
      data.join(CSV_OPTIONS[:col_sep]) + "\r\n"
    end
  end
end
