# frozen_string_literal: true

class AddCategoryPostToPost < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :category_post_id, :integer
  end
end
