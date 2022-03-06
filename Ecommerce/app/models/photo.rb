# frozen_string_literal: true

class Photo < ApplicationRecord
  belongs_to :product
  has_many_attached :images
end
