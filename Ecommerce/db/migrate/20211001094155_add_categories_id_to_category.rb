# frozen_string_literal: true

class AddCategoriesIdToCategory < ActiveRecord::Migration[6.1]
  def change
    add_column :categories, :categories_id, :integer
  end
end
