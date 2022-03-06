# frozen_string_literal: true

class AddApiTokenDigestToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :api_token_digest, :string
  end
end
