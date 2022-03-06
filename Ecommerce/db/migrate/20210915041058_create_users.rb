# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :username
      t.string :mobile
      t.string :gender
      t.integer :admin, limit: 2
      t.text :profile

      t.timestamps
    end
  end
end
