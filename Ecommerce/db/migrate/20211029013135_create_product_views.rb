# frozen_string_literal: true

class CreateProductViews < ActiveRecord::Migration[6.1]
  def change
    create_table :product_views do |t|
      t.integer :product_id
      t.string :ip_address

      t.timestamps
    end
  end
end
