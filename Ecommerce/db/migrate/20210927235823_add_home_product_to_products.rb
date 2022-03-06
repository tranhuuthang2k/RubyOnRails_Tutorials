# frozen_string_literal: true

class AddHomeProductToProducts < ActiveRecord::Migration[6.1]
  def change
    add_column :products, :show_home, :integer
  end
end
