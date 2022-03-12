# frozen_string_literal: true

class User < ApplicationRecord
  attr_accessor :remember_token

  before_save :downcase_email
  has_secure_password
  validates :name, presence: true, length: { minimum: 2 }
  validates :date_of_birth, format: { with: %r{\d{2}/\d{2}/\d{4}}, message: 'date of birth must be format dd/mm/yy' }
  validates :age, numericality: true, numericality: { message: 'must be number' }
  validates :gender, presence: true
  validates :email, presence: true, uniqueness: true, length: { maximum: 50, minimum: 2 },
                    format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone, numericality: true, length: { maximum: 12, minimum: 9 },
                    numericality: { message: 'phone be number' }

  def downcase_email
    email.downcase!
  end

  has_many :microposts
  self.per_page = 5

  def self.digest(string)
    cost = if ActiveModel::SecurePassword.min_cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end
    BCrypt::Password.create string, cost: cost
  end

  def authenticated?(remember_token)
    BCrypt::Password.new(remember_digest).is_password? remember_token
  end

  class << self
    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def forget
    update_attribute :remember_digest, nil
  end

  def remember
    self.remember_token = User.new_token # create random token
    update_attribute :remember_digest, User.digest(remember_token) # bcryt token & save db
  end
end
