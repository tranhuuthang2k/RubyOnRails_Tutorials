# frozen_string_literal: true

class AddEncodeToComments < ActiveRecord::Migration[6.1]
  def change
    add_column :comments, :reply_comment_id, :integer
    add_column :comments, :main_id, :integer
  end
end
