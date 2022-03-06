# frozen_string_literal: true

class Notification < ApplicationRecord
  scope :newest, -> { order(created_at: :desc) }
  has_rich_text :content
  validates :title, presence: true
  validates :content, presence: true
  rails_admin do
    create do
      field :title
      field :content
    end

    edit do
      include_all_fields # all other default fields will be added after, conveniently
      exclude_fields :created_at # but you still can remove fields
    end

    configure :created_at do
      visible false # so it's not on new/edit
    end

    configure :updated_at do
      visible false # so it's not on new/edit
    end
  end
end
