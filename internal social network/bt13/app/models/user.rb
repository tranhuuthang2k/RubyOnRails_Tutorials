class User < ApplicationRecord
    attr_accessor :remember_token, :activation_token
    before_save :downcase_email
    before_create :create_activation_digest
    has_secure_password
    validates :name, presence: true,length: { minimum: 2 }
    validates :date_of_birth, format: { with: /\d{2}\/\d{2}\/\d{4}/,message: "date of birth must be format dd/mm/yy" }
    validates :age, numericality: true, numericality:{message:"must be number"}
    validates :gender, presence: true
    validates :email, presence: true,uniqueness: true,length: { maximum: 50,minimum: 2 },format: { with: URI::MailTo::EMAIL_REGEXP } 
    validates :phone, numericality: true, length: { maximum: 12,minimum: 9 }, numericality:{message:"phone be number"}
    # validates :password, confirmation: true, presence: true, length: { minimum: 8 }
    validate :password_character
    validate :password_lower_case
    validate :password_uppercase
    validate :password_special_char
    validate :password_contains_number
   
    def password_character
        return if self.password.length > 8
        errors.add :password, 'must contain at least 8 character'  
    end

    def password_uppercase
        return if !!password.match(/\p{Upper}/)
        errors.add :password, ' must contain at least 1 uppercase '
    end
    
    def password_lower_case
        return if !!password.match(/\p{Lower}/)
        errors.add :password, ' must contain at least 1 lowercase '
    end
    
    def password_special_char
        special = "?<>',?[]}{=-)(*&^%$#`~{}!"
        regex = /[#{special.gsub(/./){|char| "\\#{char}"}}]/
        return if password =~ regex
        errors.add :password, ' must contain special character'
    end
    
    def password_contains_number
        return if password.count("0-9") > 0
        errors.add :password, ' must contain at least one number'
    end


    def downcase_email
        self.email.downcase!
    end
    
    has_many :microposts
    self.per_page = 5

    def User.digest string
        cost = if ActiveModel::SecurePassword.min_cost
        BCrypt::Engine::MIN_COST
        else
            BCrypt::Engine.cost
        end
            BCrypt::Password.create string, cost: cost
    end

    def authenticated? attribute, token
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
        self.remember_token = User.new_token  #create random token
        update_attribute :remember_digest, User.digest(remember_token) #bcryt token & save db
    end
    
    def create_activation_digest
        self.activation_token = User.new_token
        self.activation_digest = User.digest(activation_token)  #update activation_digest to db
    end 
    

    # def send_activation_email
    #     UserMailer.account_activation(self).deliver_now
    # end
    # def activate
    #     update_columns activated: true, activated_at: Time.zone.now
    # end

end
