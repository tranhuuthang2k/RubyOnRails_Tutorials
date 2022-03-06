# frozen_string_literal: true

class City < ApplicationRecord
  has_many :shipping_cities, dependent: :destroy
  has_many :shippings, through: :shipping_cities
end
