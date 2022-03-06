# frozen_string_literal: true

class CreateCartItems < ActiveRecord::Migration[6.1]
  def change
    create_table :cart_items do |t|
      t.integer :product_id
      t.float :price
      t.float :discount
      t.integer :quantily, limit: 6
      t.integer :active

      t.timestamps
    end
  end
end
