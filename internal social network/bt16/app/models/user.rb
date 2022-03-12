# frozen_string_literal: true

class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token, :rspw_token

  has_many :microposts, dependent: :destroy
  has_many :comments
  before_save :downcase_email
  before_create :create_activation_digest
  has_secure_password
  validates :name, presence: true, length: { minimum: 2 }
  validates :date_of_birth, format: { with: %r{\d{2}/\d{2}/\d{4}}, message: 'date of birth must be format dd/mm/yy' }
  validates :age, numericality: true, numericality: { message: 'must be number' }
  validates :gender, presence: true
  validates :email, presence: true, uniqueness: true, length: { maximum: 50, minimum: 2 },
                    format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone, numericality: true, length: { maximum: 12, minimum: 9 },
                    numericality: { message: 'phone be number' }
  PASSWORD_FORMAT = /\A(?=.{8,})(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[[:^alnum:]])/x.freeze
  validates :password,
            format: { with: PASSWORD_FORMAT, length: { minimum: 8 },
                      message: 'must contain at least one lowercase, one number, one special letter, length 8 character' }

  def downcase_email
    email.downcase!
  end

  self.per_page = 5

  def self.digest(string)
    cost = if ActiveModel::SecurePassword.min_cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end
    BCrypt::Password.create string, cost: cost
  end

  def authenticated?(attribute, token)
    digest = send "#{attribute}_digest"
    return false if digest.nil?

    BCrypt::Password.new(digest).is_password? token
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

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)  # update activation_digest to db
  end

  def create_token_digest_rspw
    self.rspw_token = User.new_token
    update_columns reset_digest: User.digest(rspw_token), reset_sent_at: Time.zone.now
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < 2.minutes.ago
  end
end
