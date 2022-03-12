# frozen_string_literal: true

class AddYearAndSChoolToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :year, :date
    add_column :users, :school, :string
  end
end
