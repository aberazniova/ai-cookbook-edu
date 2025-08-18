class User < ApplicationRecord
  devise :database_authenticatable,
    :registerable,
    :validatable,
    :jwt_authenticatable,
    # We'll rely only on short TTL with refresh tokens, no denylist for now
    jwt_revocation_strategy: Devise::JWT::RevocationStrategies::Null

  validate :strong_password

  has_many :refresh_tokens, dependent: :delete_all
  has_many :recipes, dependent: :destroy
  has_many :conversations, dependent: :destroy

  PASSWORD_REGEX = /\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d).+\z/

  private

  def strong_password
    return if password.blank?

    unless password.match?(PASSWORD_REGEX)
      errors.add(:password, "must include at least one lowercase letter, one uppercase letter, and one digit")
    end
  end
end
