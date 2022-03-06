# frozen_string_literal: true

class CreateOrderItems < ActiveRecord::Migration[6.1]
  def change
    create_table :order_items do |t|
      t.integer :user_id
      t.text :product_order
      t.string :status

      t.timestamps
    end
  end
end
