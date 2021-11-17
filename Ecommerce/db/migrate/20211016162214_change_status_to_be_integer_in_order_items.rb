class ChangeStatusToBeIntegerInOrderItems < ActiveRecord::Migration[6.1]
  def change
    change_column :order_items, :status, :integer

  end
end
