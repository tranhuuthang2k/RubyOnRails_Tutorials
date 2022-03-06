# frozen_string_literal: true

class CreateVouchers < ActiveRecord::Migration[6.1]
  def change
    create_table :vouchers do |t|
      t.string :code
      t.datetime :expire
      t.float :cost

      t.timestamps
    end
  end
end
