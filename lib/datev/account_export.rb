require 'datev/export'
require 'datev/account_header'
require 'datev/account'

module Datev
  class AccountExport < Export
    self.header_class = AccountHeader
    self.row_class = Account
  end
end
