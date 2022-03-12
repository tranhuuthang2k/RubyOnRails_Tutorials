# frozen_string_literal: true

class AddDateToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :activated_at, :string
    add_column :users, :datetime, :string
  end
end
