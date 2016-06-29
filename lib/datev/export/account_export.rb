module Datev
  class AccountExport < Export
    self.header_class = AccountHeader
    self.row_class = Account
  end
end
