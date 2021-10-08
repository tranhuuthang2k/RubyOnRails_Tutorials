class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      t.integer :user_id
      t.integer :micropost_id
      t.text :content

      t.timestamps
    end
    add_index :comments, [:user_id, :micropost_id]
  end
end
