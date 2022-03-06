# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :product
  belongs_to :user
  has_one_attached :image

  default_scope { order(created_at: :desc) }
end
