# frozen_string_literal: true

class AddUserIdToProductViews < ActiveRecord::Migration[6.1]
  def change
    add_column :product_views, :user_id, :integer
  end
end
