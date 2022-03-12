# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :micropost
  validates :user_id, presence: true
  validates :content, presence: true
  scope :newest, -> { order(created_at: :desc) }
  self.per_page = 5
end
