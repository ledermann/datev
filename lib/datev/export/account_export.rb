require 'datev/export'
require 'datev/base/header/account_header'
require 'datev/base/account'

module Datev
  class AccountExport < Export
    self.header_class = AccountHeader
    self.row_class = Account
  end
end
