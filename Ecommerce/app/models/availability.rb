# frozen_string_literal: true

class Availability < ApplicationRecord
  has_one :product
  validates :name, presence: true, length: { maximum: 1000 }
  validates :number_product, presence: true
  validates :status, presence: true
  scope :by_product_sold, ->(product_sold) { where('product_sold > ?', product_sold) }
  scope :by_month_year, lambda { |month, year|
    where('extract(year from created_at) = ? and extract(month from created_at) = ?', year, month)
  }
  # after_update :update_availability, if: :published_changed?

  after_create do
    update_number_instock
  end
  def published_changed?
    true if number_product - product_sold != number_instock
    true
  end

  def update_availability
    # self.update(:id => id, :number_instock => 3)
    # self.update_attribute(:number_instock, 3)
  end
  # after_save do
  #   update_number_instock if number_instock != number_product
  # end

  def update_number_instock
    Availability.find(id).update_attribute(:number_instock, number_product)
  end
  rails_admin do
    create do
      exclude_fields :product_sold
      field :status, :enum do
        enum do
          [['Instock', 1], ['Outstock', 0]]
        end
      end
      exclude_fields :number_instock, :is_ordering  # but you still can remove fields
    end
    edit do
      field :name
      field :number_product
      field :product_sold
      field :number_instock
      field :is_ordering
      field :status, :enum do
        enum do
          [['Instock', 1], ['Outstock', 0]]
        end
      end
      field :product
    end
    list do
      field :id
      field :name
      field :number_product
      field :number_instock
      field :product_sold
      field :is_ordering
      field :status, :enum do
        enum do
          [['Instock', 1], ['Outstock', 0]]
        end
      end
      field :created_at
      field :updated_at
    end
  end
end
