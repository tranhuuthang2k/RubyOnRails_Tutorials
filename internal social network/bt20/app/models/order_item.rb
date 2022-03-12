# frozen_string_literal: true

class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product
  before_save :finalize

  def unit_price
    if persisted?
      self[:unit_price]
    else
      product.price # OrderItem.product.price
    end
  end

  def total_price
    unit_price * quantity # OrderItem.unit_price * OrderItem.quantity
  end

  private

  def product_present
    errors.add(:product, 'is not valid or is not active.') if product.nil?
  end

  def order_present
    errors.add(:order, 'is not a valid order.') if order.nil?
  end

  def finalize
    self[:unit_price] = unit_price
    self[:total_price] = total_price # quantity * self[:unit_price]
  end
end
