# frozen_string_literal: true

class Comment < ApplicationRecord
  default_scope { order(created_at: :desc) }
  belongs_to :product
  belongs_to :user
  has_one_attached :image
  has_many :comment_childrens, class_name: Comment.name, foreign_key: 'reply_comment_id', dependent: :destroy
  belongs_to :comment_parent, foreign_key: 'reply_comment_id', class_name: Comment.name, optional: true
end
