# frozen_string_literal: true

class ProductFavorite < ApplicationRecord
  scope :newest, -> { order(created_at: :desc) }
  belongs_to :user
  belongs_to :product
end
