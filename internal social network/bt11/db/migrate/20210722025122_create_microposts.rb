# frozen_string_literal: true

class CreateMicroposts < ActiveRecord::Migration[6.1]
  def change
    create_table :microposts do |t|
      t.integer :user_id
      t.text :content
      t.references :user, index: true

      t.timestamps
    end
  end
end
