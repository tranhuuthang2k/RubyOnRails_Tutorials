# frozen_string_literal: true

class KeywordSearch < ApplicationRecord
  scope :by_keywords, lambda { |month, year|
                        where('extract(month from created_at) = ?', month).where('extract(year from created_at) = ?', year).order('count ASC')
                      }
end
