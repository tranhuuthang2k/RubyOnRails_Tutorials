# frozen_string_literal: true

class AddActivationToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :activation_digest, :string
    add_column :users, :activated, :boolean
  end
end
