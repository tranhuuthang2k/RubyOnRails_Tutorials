# frozen_string_literal: true

class CreateCarts < ActiveRecord::Migration[6.1]
  def change
    create_table :carts do |t|
      t.string :session_id
      t.string :token
      t.integer :status
      t.string :username
      t.string :email
      t.string :mobile
      t.string :gender
      t.string :address
      t.string :city
      t.string :province
      t.string :country

      t.timestamps
    end
  end
end
