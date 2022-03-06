# frozen_string_literal: true

class AddAvailabilityIdToProducts < ActiveRecord::Migration[6.1]
  def change
    add_column :products, :availability_id, :string
  end
end
