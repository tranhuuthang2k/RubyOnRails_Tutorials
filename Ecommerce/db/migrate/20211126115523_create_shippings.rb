# frozen_string_literal: true

class CreateShippings < ActiveRecord::Migration[6.1]
  def change
    create_table :shippings do |t|
      t.string :name
      t.string :description
      t.float :price

      t.timestamps
    end
  end
end
