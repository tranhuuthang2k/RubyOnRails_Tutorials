# frozen_string_literal: true

class AddFeeToOrderItems < ActiveRecord::Migration[6.1]
  def change
    add_column :order_items, :fee, :float
  end
end
