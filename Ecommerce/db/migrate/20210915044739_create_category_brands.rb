# frozen_string_literal: true

class CreateCategoryBrands < ActiveRecord::Migration[6.1]
  def change
    create_table :category_brands do |t|
      t.integer :brand_id
      t.integer :category_id

      t.timestamps
    end
  end
end
