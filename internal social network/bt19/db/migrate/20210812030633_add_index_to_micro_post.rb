class AddIndexToMicroPost < ActiveRecord::Migration[6.1]
  def change
    add_index :microposts, [:user_id, :created_at]
  end
end
