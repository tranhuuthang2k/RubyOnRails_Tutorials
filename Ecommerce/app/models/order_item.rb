class OrderItem < ApplicationRecord
  before_update :update_sold
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
  STOCK = { 'Outstock': 0, 'Instock': 1 }.freeze # 0 -> pending, 1 -> confirm, 2 -> cancel

  rails_admin do
    create do
      field :title
      field :content
    end

    edit do
      include_all_fields # all other default fields will be added after, conveniently
      field :status, :enum do
        enum do
          [['Pending', 0], ['Confirmed', 1], ['Cancel', 2]]
        end
        help 'Pending -> 0, confirmed -> 1, cancel -> 2'
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
                                number_instock: availability.number_instock - quantily,
                                status: status)
  end

  def decrement(availability, quantily, status)
    availability.update_columns(product_sold: availability.product_sold - quantily,
                                number_instock: availability.number_instock + quantily,
                                status: status)
  end

  def update_sold
    if OrderItem.find(id).status != status
      product_orders = JSON.parse(product_order)
      ids = product_orders.pluck('id')
      products = Product.where(ids)
      product_orders.each do |product_order|
        product = products.find(product_order['id'])
        availability = product.availability
        if status == 1
          if availability.number_product > availability.product_sold + product_order['quantity'].to_i
            increment(availability, product_order['quantity'].to_i, OrderItem::STOCK[:Instock]) # instock

          elsif availability.number_product == availability.product_sold + product_order['quantity'].to_i
            increment(availability, product_order['quantity'].to_i,  OrderItem::STOCK[:Outstock]) # out

          end

        elsif status == 0
          if availability.number_product > availability.product_sold - product_order['quantity'].to_i
            decrement(availability, product_order['quantity'].to_i,  OrderItem::STOCK[:Instock])

          elsif availability.number_product == availability.product_sold - product_order['quantity'].to_i
            increment(availability, product_order['quantity'].to_i, OrderItem::STOCK[:Outstock])

          end
        end
      end
    end
  end
end
