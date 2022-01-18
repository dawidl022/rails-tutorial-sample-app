class User < ApplicationRecord
  attr_accessor :remember_token

  VALID_EMAIL_REGEX = /\A[^.](?:.*[^.])?@[0-9a-z](?:[0-9a-z-])*(?:\.[0-9a-z](?:[0-9a-z])*)*\Z/i

  before_save { self.email = email.downcase }

  validates :name, length: { maximum: 50 }
  validates :email, length: { maximum: 255 },
    format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  validates_presence_of :name, :email

  has_secure_password

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
    remember_digest
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def session_token
    remember_digest || remember
  end

  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end
end
