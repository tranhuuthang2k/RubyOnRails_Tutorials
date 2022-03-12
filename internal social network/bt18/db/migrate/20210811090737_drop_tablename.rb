# frozen_string_literal: true

class DropTablename < ActiveRecord::Migration[6.1]
  def change
    drop_table :products
  end
end
