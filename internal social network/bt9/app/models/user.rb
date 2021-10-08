class User < ApplicationRecord
    before_save :downcase_email
    has_secure_password
    validates :name, presence: true,length: { minimum: 2 }
    validates :date_of_birth, format: { with: /\d{2}\/\d{2}\/\d{4}/,message: "date of birth must be format dd/mm/yy" }
    validates :age, numericality: true, numericality:{message:"must be number"}
    validates :gender, presence: true
    validates :email, presence: true,uniqueness: true,length: { maximum: 50,minimum: 2 },format: { with: URI::MailTo::EMAIL_REGEXP } 
    def downcase_email
        self.email.downcase!
    end
end
