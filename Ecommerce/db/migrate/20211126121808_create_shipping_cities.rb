# frozen_string_literal: true

class CreateShippingCities < ActiveRecord::Migration[6.1]
  def change
    create_table :shipping_cities do |t|
      t.integer :city_id
      t.integer :shipping_id

      t.timestamps
    end
  end
end
