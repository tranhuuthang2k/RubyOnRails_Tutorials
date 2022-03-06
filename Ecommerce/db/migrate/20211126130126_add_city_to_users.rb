# frozen_string_literal: true

class AddCityToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :city_id, :integer
  end
end
