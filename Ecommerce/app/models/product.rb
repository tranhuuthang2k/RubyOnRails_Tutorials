# frozen_string_literal: true

class Product < ApplicationRecord
  # https://stackoverflow.com/questions/12165405/is-there-a-way-to-pass-html-css-options-to-rails-admin-inputs/12428986
  SHOW_HOME = { feature: 1, recomand: 0 }.freeze
  STATUS = { 'pending': 0, 'confirmed': 1, 'cancel': 2 }.freeze # 0 -> pending, 1 -> confirm, 2 -> cancel
  scope :show_products, ->(val) { where.not(show_home: val.to_s).limit(val === 0 ? 9 : 12) }
  scope :by_ids, ->(ids) { where(id: ids) }

  has_rich_text :content

  has_one_attached :image
  validates :title, presence: true, length: { maximum: 40 }
  validates :price, numericality: true
  validates :content, presence: true
  validates :image, presence: true
  validates :sizes, presence: true
  has_many :product_categories
  has_many :categories, through: :product_categories

  has_many :product_sizes
  has_many :sizes, through: :product_sizes

  has_many :photos
  has_many :comments, dependent: :destroy
  has_many :product_favorites
  has_many :product_rates
  has_many :product_views, dependent: :destroy
  accepts_nested_attributes_for :photos
  belongs_to :availability
  belongs_to :brand
  after_commit :add_default_image
  before_save :uppercase_title

  def uppercase_title
    title.upcase!
  end

  def add_default_image
    return if image.attached?

    image.attach(io: File.open(Rails.root.join('app', 'assets', 'images', 'product_default.jpg')),
                 filename: 'product_default.jpg',
                 content_type: 'image/jpg')
  end

  rails_admin do
    configure :product_views do
      pretty_value do
        util = bindings[:object]
        %(#{util.product_views.count} 👁️‍🗨️ )
      end
      children_fields [:product_id] # will be used for searching/filtering, first field will be used for sorting
      read_only true # won't be editable in forms (alternatively, hide it in edit section)
    end
    create do
      field :title
      field :price
      field :price_old
      field :sizes
      # field :description
      field :content

      field :availability
      field :categories
      field :categories_id, :enum do
        enum do
          Category.all.collect { |c| [c.name, c.id] }
        end
      end
      field :image
      field :brand_id, :enum do
        enum do
          Brand.all.collect { |c| [c.name, c.id] }
        end
      end
      field :user_id, :hidden do
        default_value do
          bindings[:view]._current_user.id
        end
      end
      field :show_home, :enum do
        enum do
          [['FEATURES', 1], ['RECOMMENDED', 0]]
        end
      end
    end

    list do
      include_all_fields # all other default fields will be added after, conveniently
      field :product_views
    end

    edit do
      include_all_fields # all other default fields will be added after, conveniently
      field :show_home, :enum do
        enum do
          [['FEATURES', 1], ['RECOMMENDED', 0]]
        end
      end
      field :categories_id, :enum do
        enum do
          Category.all.collect { |c| [c.name, c.id] }
        end
      end
      exclude_fields :created_at, :product_sizes, :product_favorites, :comments, :product_rates, :description # but you still can remove fields
    end

    configure :created_at do
      visible false # so it's not on new/edit
    end

    configure :updated_at do
      visible false # so it's not on new/edit
    end
  end
end
