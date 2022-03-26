# frozen_string_literal: true

class Brand < ApplicationRecord
  has_many :products
  scope :by_month_year, lambda { |month, year|
    where('extract(month from created_at) = ?', month).where('extract(year from created_at) = ?', year)
  }
end
