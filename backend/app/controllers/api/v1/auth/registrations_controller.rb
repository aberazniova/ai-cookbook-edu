module Api
  module V1
    module Auth
      class RegistrationsController < Devise::RegistrationsController
        include AuthTokensIssuer

        respond_to :json

        # POST /api/v1/auth/sign_up
        def create
          build_resource(sign_up_params)
          resource.save

          if resource.persisted?
            issue_refresh_and_access_token(resource)

            render json: resource, serializer: UserSerializer, status: :created
          else
            render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
          end
        end

        private

        def sign_up_params
          params.require(:user).permit(:email, :password, :password_confirmation)
        end
      end
    end
  end
end
