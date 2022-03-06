# frozen_string_literal: true

class Category < ApplicationRecord
  has_many :product_categories
  has_many :products, through: :product_categories
  scope :show_category, -> { where categories_id: nil }

  validates :name, presence: true, length: { maximum: 20 }
  rails_admin do
    create do
      field :name
      field :categories_id, :enum do
        enum do
          Category.all.collect { |c| [c.name, c.id] }
        end
      end
    end
  end
end
