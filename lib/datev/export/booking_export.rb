require 'datev/export'
require 'datev/base/header/booking_header'
require 'datev/base/booking'

module Datev
  class BookingExport < Export
    self.header_class = BookingHeader
    self.row_class = Booking
  end
end
