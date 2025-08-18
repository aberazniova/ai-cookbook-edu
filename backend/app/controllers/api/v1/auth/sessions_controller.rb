module Api
  module V1
    module Auth
      class SessionsController < Devise::SessionsController
        include AuthTokensIssuer

        # Skip Devise's signed-out check so our revoke/clear cookie logic
        # always runs and the response can emit Set-Cookie deletion headers.
        skip_before_action :verify_signed_out_user, only: :destroy

        respond_to :json

        # POST /api/v1/auth/sign_in
        def create
          user = User.find_by(email: email)

          if user&.valid_password?(password)
            issue_refresh_and_access_token(user)

            render json: user, serializer: UserSerializer, status: :ok
          else
            render json: { errors: ["Invalid email or password"] }, status: :unauthorized
          end
        end

        # DELETE /api/v1/auth/sign_out
        def destroy
          sign_out(resource_name)

          revoke_refresh_token_from_cookie
          clear_cookies

          head :no_content
        end

        private

        def email
          params.dig(:user, :email)
        end

        def password
          params.dig(:user, :password)
        end

        def clear_cookies
          cookies.delete(:refresh_token, path: "/api/v1/auth")
          cookies.delete(:conversation_id)
        end

        def revoke_refresh_token_from_cookie
          raw = cookies.encrypted[:refresh_token]
          return if raw.blank?

          if (rec = RefreshToken.find_active_by_raw_token(raw))
            rec.revoke!
          end
        end
      end
    end
  end
end
