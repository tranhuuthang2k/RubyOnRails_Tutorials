# frozen_string_literal: true

class ChangeColumnNameAvailabilities < ActiveRecord::Migration[6.1]
  def change
    rename_column :availabilities, :quantily_product, :number_product
  end
end
