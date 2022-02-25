class ChangeColumnDiscount < ActiveRecord::Migration[6.1]
  def change
    rename_column :products, :discount, :price_old
  end
end
