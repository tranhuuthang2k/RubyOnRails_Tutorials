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
  rails_admin do
    create do
      field :title
      field :content
    end

    edit do
      include_all_fields # all other default fields will be added after, conveniently
      field :status do
        help 'Pending -> 0, confirm -> 1, cancel -> 2'
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

  def update_sold
    ids = JSON.parse(product_order).collect { |b| b['id'] }
    if status == 1
      ids.each do |id|
        product = Product.find(id)
        product.update_attribute(:sold, product.sold + 1)
      end
    elsif status == 0 || status == 2
      ids.each do |id|
        product = Product.find(id) 
        if product.sold > 0
          product.update_attribute(:sold, product.sold - 1)
        end
      end
    end
  end
end
