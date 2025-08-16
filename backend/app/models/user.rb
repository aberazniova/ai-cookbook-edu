class User < ApplicationRecord
  devise :database_authenticatable,
         :registerable,
         :validatable,
         :jwt_authenticatable,
         # We'll rely only on short TTL with refresh tokens, no denylist for now
         jwt_revocation_strategy: Devise::JWT::RevocationStrategies::Null

  has_many :refresh_tokens, dependent: :delete_all
end
