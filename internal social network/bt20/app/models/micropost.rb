# frozen_string_literal: true

class Micropost < ApplicationRecord
  belongs_to :user
  has_many :comments
  scope :newest, -> { order(created_at: :desc) }
  has_one_attached :image
  validates :content, presence: true
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validates :image, content_type: { in: %w[image/jpeg image/gif image/png],
                                    message: 'must be a valid image format' },
                    size: { less_than: 5.megabytes,
                            message: 'should be less than 5MB' }
  self.per_page = 5
end
