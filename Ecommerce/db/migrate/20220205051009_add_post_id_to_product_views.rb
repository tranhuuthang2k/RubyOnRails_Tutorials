# frozen_string_literal: true

class AddPostIdToProductViews < ActiveRecord::Migration[6.1]
  def change
    add_column :product_views, :post_id, :integer
    add_column :product_views, :ip_post, :string
  end
end
