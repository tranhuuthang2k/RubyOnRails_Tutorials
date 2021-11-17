class ProductView < ApplicationRecord
    scope :newest, -> { order(created_at: :desc) }
    belongs_to :product
end
