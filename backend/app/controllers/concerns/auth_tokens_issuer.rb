module AuthTokensIssuer
  extend ActiveSupport::Concern

  private

  def issue_refresh_and_access_token(user)
    set_access_token(user)
    issue_refresh_token(user)
  end

  def issue_refresh_token(user)
    result = RefreshTokens::Generate.call(user: user)

    cookies.encrypted[:refresh_token] = {
      value: result.raw_token,
      httponly: true,
      secure: Rails.env.production?,
      same_site: :lax,
      expires: result.record.expires_at
    }
  end

  def set_access_token(user)
    warden.set_user(user, store: false)
  end
end
