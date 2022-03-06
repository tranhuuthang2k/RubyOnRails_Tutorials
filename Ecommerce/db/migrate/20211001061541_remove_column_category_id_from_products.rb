# frozen_string_literal: true

class RemoveColumnCategoryIdFromProducts < ActiveRecord::Migration[6.1]
  def change
    remove_column :products, :category_id, :integer
  end
end
