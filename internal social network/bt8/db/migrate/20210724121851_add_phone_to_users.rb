# frozen_string_literal: true

class AddPhoneToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :phone, :integer
    add_column :users, :age, :integer
  end
end
