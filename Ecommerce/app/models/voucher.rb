# frozen_string_literal: true

class Voucher < ApplicationRecord
  scope :by_vouchers, lambda { |month, year|
                        where('extract(month from created_at) = ?', month).where('extract(year from created_at) = ?', year)
                      }
end
