# frozen_string_literal: true

class ProductView < ApplicationRecord
  scope :newest, -> { order(created_at: :desc) }
  scope :by_month_year, lambda { |month, year|
                          where('extract(month from created_at) = ?', month).where('extract(year from created_at) = ?', year)
                                                                            .order('product_id DESC')
                        }
  belongs_to :product
  belongs_to :post
end
