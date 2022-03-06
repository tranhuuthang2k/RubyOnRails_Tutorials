# frozen_string_literal: true

class Shipping < ApplicationRecord
  has_many :shipping_cities, dependent: :destroy
  has_many :cities, through: :shipping_cities
  validates :name, presence: true
  validates :price, presence: true

  rails_admin do
    create do
      include_all_fields # all other default fields will be added after, conveniently
      exclude_fields :shipping_cities
    end

    list do
      include_all_fields # all other default fields will be added after, conveniently
      field :shipping_cities
    end

    edit do
      include_all_fields # all other default fields will be added after, conveniently

      exclude_fields :shipping_cities # but you still can remove fields
    end

    configure :created_at do
      visible false # so it's not on new/edit
    end

    configure :updated_at do
      visible false # so it's not on new/edit
    end
  end
end
