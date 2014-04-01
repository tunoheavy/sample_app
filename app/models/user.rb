class User < ActiveRecord::Base
  validates :name, presence: true, length: {maximum: 50}
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, 
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  before_save { self.email = email.downcase }
  
  validates :password, length: { minimum: 6 }

  has_secure_password
 
  before_create :create_remember_token

  def User.new_remember_token # 3
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token) # 4
    Digest::SHA1.hexdigest(token.to_s) # SHA1 faster than bcrypt
  end

  private # hidden from everyone except the User model

  def create_remember_token # 2
    self.remember_token = User.encrypt(User.new_remember_token) # self = the object being created
  end

end
