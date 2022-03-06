# frozen_string_literal: true

class AddDescriptionToProducts < ActiveRecord::Migration[6.1]
  def change
    add_column :products, :description, :text, after: :price
  end
end
