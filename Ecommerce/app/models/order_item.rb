class OrderItem < ApplicationRecord
  belongs_to :user
  default_scope { order(created_at: :desc) }
  scope :total_order, ->(total_order) { where('total_order > ?', total_order) }
  scope :this_status, ->(status) { where('status = ?', status) }
  scope :this_month, lambda { |year, month|
                       where('extract(year from created_at) = ? and extract(month from created_at) = ?', year, month)
                     }
end
