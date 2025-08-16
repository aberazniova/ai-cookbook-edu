module Api
  module V1
    module Auth
      class TokensController < ApplicationController
        include AuthTokensIssuer
        respond_to :json

        # POST /api/v1/auth/refresh
        def refresh
          return render json: { errors: ["Invalid refresh token"] }, status: :unauthorized unless verified_token

          user = verified_token.user
          verified_token.revoke! # rotating refresh token

          issue_refresh_and_access_token(user)
          render json: user, serializer: UserSerializer, status: :ok
        end

        private

        def refresh_token
          cookies.encrypted[:refresh_token]
        end

        def verified_token
          @_verified_token ||= RefreshToken.find_active_by_raw_token(refresh_token)
        end
      end
    end
  end
end
