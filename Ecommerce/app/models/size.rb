# frozen_string_literal: true

class Size < ApplicationRecord
  has_many :product_sizes
  has_many :products, through: :product_sizes
end
