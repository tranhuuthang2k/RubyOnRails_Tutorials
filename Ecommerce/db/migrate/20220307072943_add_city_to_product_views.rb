# frozen_string_literal: true

class AddCityToProductViews < ActiveRecord::Migration[6.1]
  def change
    add_column :product_views, :city, :string
  end
end
