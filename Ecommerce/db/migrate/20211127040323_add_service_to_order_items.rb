# frozen_string_literal: true

class AddServiceToOrderItems < ActiveRecord::Migration[6.1]
  def change
    add_column :order_items, :service, :string
  end
end
