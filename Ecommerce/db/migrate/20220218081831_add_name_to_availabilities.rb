# frozen_string_literal: true

class AddNameToAvailabilities < ActiveRecord::Migration[6.1]
  def change
    add_column :availabilities, :name, :string, after: :id
  end
end
