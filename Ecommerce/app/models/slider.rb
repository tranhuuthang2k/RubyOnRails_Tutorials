# frozen_string_literal: true

class Slider < ApplicationRecord
  has_one_attached :image
  validates :logoName, presence: true
  validates :title, presence: true, length: { maximum: 50 }
  validates :description, presence: true, length: { maximum: 50 }
  validates :image, presence: true
end
