class User < ApplicationRecord
    before_save :downcase_email
    validates :name, presence: true
    validates :gender, presence: true
    validates :email, presence: true,uniqueness: true,length: { maximum: 50,minimum: 2 },format: { with: URI::MailTo::EMAIL_REGEXP } 
    def downcase_email
        self.email.downcase!
    end
    has_secure_password
end
