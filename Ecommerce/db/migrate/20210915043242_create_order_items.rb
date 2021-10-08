class CreateOrderItems < ActiveRecord::Migration[6.1]
  def change
    create_table :order_items do |t|
      t.integer :product_id
      t.float :price
      t.float :discount
      t.integer :quantily,:limit=>6

      t.timestamps
    end
  end
end
