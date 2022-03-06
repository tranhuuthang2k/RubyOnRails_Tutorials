# frozen_string_literal: true

class AddSoldToProducts < ActiveRecord::Migration[6.1]
  def change
    add_column :products, :sold, :integer, default: 0
  end
end
