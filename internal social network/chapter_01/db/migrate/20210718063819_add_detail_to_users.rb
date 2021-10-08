class AddDetailToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :date_of_birth, :string
    add_column :users, :gender, :string
  end
end
