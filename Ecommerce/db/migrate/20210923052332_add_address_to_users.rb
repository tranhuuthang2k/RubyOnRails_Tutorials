# frozen_string_literal: true

class AddAddressToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :address, :string, after: :admin
  end
end
