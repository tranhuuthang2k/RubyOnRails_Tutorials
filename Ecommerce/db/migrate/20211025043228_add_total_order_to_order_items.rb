# frozen_string_literal: true

class AddTotalOrderToOrderItems < ActiveRecord::Migration[6.1]
  def change
    add_column :order_items, :total_order, :integer
  end
end
