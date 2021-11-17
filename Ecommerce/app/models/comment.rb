class Comment < ApplicationRecord
  belongs_to :product
  belongs_to :user

  default_scope { order(created_at: :desc) }
end
