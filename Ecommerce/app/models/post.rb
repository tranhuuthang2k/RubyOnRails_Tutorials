# frozen_string_literal: true

class Post < ApplicationRecord
  scope :newest, -> { order(created_at: :desc) }
  has_rich_text :body
  has_one_attached :image
  belongs_to :user
  belongs_to :category_post
  validates :category_post_id, presence: true
  validates :title, presence: true
  validates :content, presence: true
  validates :body, presence: true
  has_many :product_views, dependent: :destroy

  rails_admin do
    create do
      field :title
      field :content
      field :body
      field :image
      field :category_post_id, :enum do
        enum do
          CategoryPost.all.collect { |c| [c.name, c.id] }
        end
      end
      field :user_id, :hidden do
        default_value do
          bindings[:view]._current_user.id
        end
      end
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
