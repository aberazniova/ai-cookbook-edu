# == Schema Information
#
# Table name: refresh_tokens
#
#  id           :integer          not null, primary key
#  user_id      :integer          not null
#  token_digest :string(255)      not null
#  expires_at   :datetime         not null
#  revoked_at   :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_refresh_tokens_on_token_digest  (token_digest) UNIQUE
#  index_refresh_tokens_on_user_id       (user_id)
#

class RefreshToken < ApplicationRecord
  belongs_to :user

  scope :active, -> { where(revoked_at: nil).where("expires_at > ?", Time.current) }

  def self.find_active_by_raw_token(raw)
    return nil if raw.blank?

    digest = digest_for(raw)
    active.find_by(token_digest: digest)
  end

  def self.digest_for(raw)
    OpenSSL::Digest::SHA256.hexdigest(raw)
  end

  def revoke!
    update!(revoked_at: Time.current)
  end

  def expired?
    expires_at <= Time.current
  end

  def revoked?
    revoked_at.present?
  end
end
