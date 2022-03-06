# frozen_string_literal: true

class ChangeStatusToBeIntegerInOrderItems < ActiveRecord::Migration[6.1]
  def change
    change_column :order_items, :status, :integer, using: 'status::integer'
  end
end
