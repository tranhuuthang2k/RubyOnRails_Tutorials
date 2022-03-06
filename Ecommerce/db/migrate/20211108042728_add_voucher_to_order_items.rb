# frozen_string_literal: true

class AddVoucherToOrderItems < ActiveRecord::Migration[6.1]
  def change
    add_column :order_items, :voucher, :float, after: :status
  end
end
