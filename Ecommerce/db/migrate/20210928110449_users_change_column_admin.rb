class UsersChangeColumnAdmin < ActiveRecord::Migration[6.1]
  def change
    change_column(:users, :admin, :boolean)
end
end
