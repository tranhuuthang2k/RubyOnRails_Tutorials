# frozen_string_literal: true

class CreateSliders < ActiveRecord::Migration[6.1]
  def change
    create_table :sliders do |t|
      t.string :logoName
      t.string :title
      t.string :description

      t.timestamps
    end
  end
end
