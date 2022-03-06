# frozen_string_literal: true

class Createtablecomment < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      t.integer :user_id
      t.integer :product_id
      t.text :content

      t.timestamps
    end
    add_index :comments, %i[user_id product_id]
  end
end
