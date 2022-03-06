# frozen_string_literal: true

class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      t.integer :category_id
      t.integer :brand_id
      t.string :title
      t.float :price
      t.float :discount

      t.timestamps
    end
    add_index :products, [:title]
    # , type: :fulltext
  end
end
