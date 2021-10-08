class Product < ApplicationRecord
  # https://stackoverflow.com/questions/12165405/is-there-a-way-to-pass-html-css-options-to-rails-admin-inputs/12428986
  SHOW_HOME = { feature: 1, recomand: 0 }
  scope :show_products, ->(val){ where.not(show_home: "#{val}").limit( val === 0 ? 8 : 3) }
  has_one_attached :image
  validates :title, presence: true
  validates :price, numericality: true
  validates :image, presence: true
  validates :description, presence: true
  has_many :product_categories
  has_many :categories, through: :product_categories
  has_many :photos
  accepts_nested_attributes_for :photos
  belongs_to :availability

  rails_admin do
    create do
      field :title
      field :price
      field :discount
      field :description
      field :image
      field :show_home, :enum do
        enum do
          [['FEATURES', 1], ['RECOMMENDED', 0]]
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
