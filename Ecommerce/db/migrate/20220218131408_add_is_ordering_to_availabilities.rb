# frozen_string_literal: true

class AddIsOrderingToAvailabilities < ActiveRecord::Migration[6.1]
  def change
    add_column :availabilities, :is_ordering, :integer, default: 0
  end
end
