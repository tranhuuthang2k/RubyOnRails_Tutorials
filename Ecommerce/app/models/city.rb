class City < ApplicationRecord
  has_many :shipping_cities, dependent: :destroy
  has_many :shippings, through: :shipping_cities
end
