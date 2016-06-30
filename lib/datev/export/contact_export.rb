module Datev
  class ContactExport < Export
    self.header_class = ContactHeader
    self.row_class = Contact
  end
end
