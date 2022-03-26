# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:facebook]

  has_one_attached :avatar
  has_many :product_favorites
  has_many :comments, dependent: :destroy
  has_many :product_rates
  has_many :order_items
  has_many :posts, dependent: :destroy
  validates :city, presence: true
  belongs_to :city
  validates :username, presence: true, length: { maximum: 20 }
  validates :mobile,  presence: true,
                      numericality: true,
                      length: { minimum: 10, maximum: 15 },
                      unless: -> { from_omniauth? }
  PASSWORD_FORMAT = /\A(?=.{8,})(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[[:^alnum:]])/x
  validates :password, format: { with: PASSWORD_FORMAT }, unless: -> { from_omniauth? }, if: -> { password.present? }

  def self.from_omniauth(auth)
    result = User.find_by(email: auth.info.email)
    return result if result

    where(provider: auth.provider, uid: auth.uid).first_or_create! do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.username = auth.info.name.split('@').first
      user.uid = auth.uid
      user.provider = auth.provider
    end
  end

  class << self
    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def generate_token
    api_token = User.new_token
    update_attribute(:api_token_digest, api_token)
    api_token
  end

  def self.digest(string)
    cost = if ActiveModel::SecurePassword.min_cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end
    BCrypt::Password.create string, cost: cost
  end

  rails_admin do
    edit do
      include_all_fields # all other default fields will be added after, conveniently
      field :admin, :enum do
        enum do
          [['User', 0], ['Admin', 1]]
        end
      end
      exclude_fields :created_at, :product_sizes, :product_favorites, :comments, :product_rates, :description # but you still can remove fields
    end
  end

  private

  def from_omniauth?
    provider && uid
  end
end
