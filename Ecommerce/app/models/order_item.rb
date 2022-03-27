# frozen_string_literal: true

class OrderItem < ApplicationRecord
  before_update :update_sold
  before_save :check_status
  belongs_to :user
  default_scope { order(created_at: :desc) }
  scope :total_order, ->(total_order) { where('total_order > ?', total_order) }
  scope :this_status, ->(status) { where('status = ?', status) }
  scope :by_orders, lambda { |month, year|
                      where('extract(month from created_at) = ?', month).where('extract(year from created_at) = ?', year)
                    }
  scope :this_month, lambda { |year, month|
    where('extract(year from created_at) = ? and extract(month from created_at) = ?', year, month)
  }
  STOCK = { 'Outstock': 0, 'Instock': 1 }.freeze

  rails_admin do
    create do
      field :title
      field :content
    end
    list do
      field :id
      field :user
      field :product_order
      field :voucher
      field :fee
      field :status, :enum do
        enum do
          [['Pending', 0], ['Confirmed', 1], ['Cancel', 2]]
        end
        help 'When canceling an order, leave the order status as pending and then choose to cancel the order 1 times.'
      end
      field :service
      field :total_order
      field :created_at
      field :updated_at
    end
    edit do
      include_all_fields # all other default fields will be added after, conveniently
      field :status, :enum do
        enum do
          [['Pending', 0], ['Confirmed', 1], ['Cancel', 2]]
        end
        help 'When canceling an order, leave the order status as pending and then choose to cancel the order 1 times.'
      end
      exclude_fields :created_at # but you still can remove fields
    end

    configure :created_at do
      visible false # so it's not on new/edit
    end

    configure :updated_at do
      visible false # so it's not on new/edit
    end
  end

  private

  def increment(availability, quantily, status)
    availability.update_columns(product_sold: availability.product_sold + quantily,
                                is_ordering: availability.is_ordering - quantily,
                                status: status)
  end

  def decrement(availability, quantily, status)
    availability.update_columns(product_sold: availability.product_sold - quantily,
                                is_ordering: availability.is_ordering + quantily,
                                status: status)
  end

  def cancle(availability, quantily)
    availability.update_columns(number_instock: availability.number_instock + quantily,
                                is_ordering: availability.is_ordering - quantily >= 0 ? availability.is_ordering - quantily : availability.is_ordering,
                                status: OrderItem::STOCK[:Instock])
  end

  def check_status
    if status == Product::STATUS[:confirmed]
      product_orders = JSON.parse(product_order)
      ids = product_orders.pluck('id')
      products = Product.where(id: ids)
      product_orders.each do |product_order|
        product = products.find(product_order['id'])
        availability = product.availability
        if availability.number_product < product_order['quantity'].to_i
          update_attribute(:status,
                           Product::STATUS[:pending])
        end
      end
    end
  end

  def update_sold
    if OrderItem.find(id).status != status
      product_orders = JSON.parse(product_order)
      ids = product_orders.pluck('id')
      products = Product.where(id: ids)
      product_orders.each do |product_order|
        product = products.find(product_order['id'])
        availability = product.availability
        if status == Product::STATUS[:confirmed]
          if availability.number_product > availability.product_sold + product_order['quantity'].to_i
            increment(availability, product_order['quantity'].to_i, OrderItem::STOCK[:Instock])

          elsif availability.number_product == availability.product_sold + product_order['quantity'].to_i
            increment(availability, product_order['quantity'].to_i,  OrderItem::STOCK[:Outstock])
          end
        elsif status == Product::STATUS[:pending]
          if (availability.product_sold - product_order['quantity'].to_i) > -1 &&
             availability.number_product > (availability.product_sold - product_order['quantity'].to_i)
            decrement(availability, product_order['quantity'].to_i,  OrderItem::STOCK[:Instock])

          elsif availability.number_product == availability.product_sold - product_order['quantity'].to_i
            increment(availability, product_order['quantity'].to_i, OrderItem::STOCK[:Outstock])

          end
        elsif status == Product::STATUS[:cancel]
          cancle(availability, product_order['quantity'].to_i)
        end
      end
    end
  end
end
