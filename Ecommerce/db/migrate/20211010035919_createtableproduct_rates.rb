# frozen_string_literal: true

class CreatetableproductRates < ActiveRecord::Migration[6.1]
  def change
    create_table :product_rates do |t|
      t.integer :user_id
      t.integer :product_id
      t.integer :rate

      t.timestamps
    end
    add_index :product_rates, %i[user_id product_id]
  end
end
