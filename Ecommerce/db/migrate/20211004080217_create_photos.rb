# frozen_string_literal: true

class CreatePhotos < ActiveRecord::Migration[6.1]
  def change
    create_table :photos do |t|
      t.integer :product_id

      t.timestamps
    end
  end
end
