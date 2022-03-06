# frozen_string_literal: true

class ShippingCity < ApplicationRecord
  belongs_to :city
  belongs_to :shipping
end
