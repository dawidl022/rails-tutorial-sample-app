class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[^.](?:.*[^.])?@[0-9a-z](?:[0-9a-z-])*(?:\.[0-9a-z](?:[0-9a-z])*)*\Z/i

  before_save { self.email = email.downcase }

  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
    format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
end
