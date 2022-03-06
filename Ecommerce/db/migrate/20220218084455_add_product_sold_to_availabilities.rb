# frozen_string_literal: true

class AddProductSoldToAvailabilities < ActiveRecord::Migration[6.1]
  def change
    add_column :availabilities, :product_sold, :integer, default: 0
  end
end
