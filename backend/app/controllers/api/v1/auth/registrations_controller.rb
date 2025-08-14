module Api
  module V1
    module Auth
      class RegistrationsController < Devise::RegistrationsController
        respond_to :json

        # POST /api/v1/auth/sign_up
        def create
          build_resource(sign_up_params)
          resource.save

          if resource.persisted?
            warden.set_user(resource, store: false) # triggers devise-jwt dispatch
            render json: user_payload(resource), status: :created
          else
            render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
          end
        end

        private

        def sign_up_params
          params.require(:user).permit(:email, :password, :password_confirmation)
        end

        def user_payload(user)
          { user: { id: user.id, email: user.email } }
        end
      end
    end
  end
end
