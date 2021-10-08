class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.string :session_id
      t.string :token
      t.integer :status
      t.float :subTotal
      t.float :itemDiscount
      t.float :tax
      t.float :shipping
      t.float :total
      t.float :discount
      t.string :username
      t.string :email
      t.string :mobile
      t.string :address
      t.string :city
      t.integer :postalCode
      t.string :country

      t.timestamps
    end
  end
end
