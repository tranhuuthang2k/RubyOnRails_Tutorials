# frozen_string_literal: true

class CreateAvailabilities < ActiveRecord::Migration[6.1]
  def change
    create_table :availabilities do |t|
      t.string :status
      t.integer :number_instock

      t.timestamps
    end
  end
end
