class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[^.](?:.*[^.])?@[0-9a-z](?:[0-9a-z-])*(?:\.[0-9a-z](?:[0-9a-z])*)*\Z/i

  before_save { self.email = email.downcase }

  validates :name, length: { maximum: 50 }
  validates :email, length: { maximum: 255 },
    format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }

  validates_presence_of :name, :email, :password

  has_secure_password
end
