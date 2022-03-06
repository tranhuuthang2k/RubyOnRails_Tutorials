# frozen_string_literal: true

class CreateCategoryPosts < ActiveRecord::Migration[6.1]
  def change
    create_table :category_posts do |t|
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end
