# frozen_string_literal: true

class CategoryPost < ApplicationRecord
  has_many :posts
end
