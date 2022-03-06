# frozen_string_literal: true

class CreateKeywordSearches < ActiveRecord::Migration[6.1]
  def change
    create_table :keyword_searches do |t|
      t.string :key_word
      t.integer :count

      t.timestamps
    end
  end
end
