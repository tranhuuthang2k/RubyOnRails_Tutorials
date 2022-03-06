# frozen_string_literal: true

class AddCategoriesIdToProducts < ActiveRecord::Migration[6.1]
  def change
    add_column :products, :categories_id, :integer
  end
end
