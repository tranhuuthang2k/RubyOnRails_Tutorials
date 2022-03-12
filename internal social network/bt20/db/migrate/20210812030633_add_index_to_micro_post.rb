# frozen_string_literal: true

class AddIndexToMicroPost < ActiveRecord::Migration[6.1]
  def change
    add_index :microposts, %i[user_id created_at]
  end
end
