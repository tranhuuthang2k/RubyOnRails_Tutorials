class Micropost < ApplicationRecord
    belongs_to :user
    validates  :content, presence: true
    self.per_page = 5
end
