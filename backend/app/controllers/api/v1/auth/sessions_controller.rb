module Api
  module V1
    module Auth
      class SessionsController < Devise::SessionsController
        respond_to :json

        # POST /api/v1/auth/sign_in
        def create
          user = User.find_by(email: email)

          if user&.valid_password?(password)
            warden.set_user(user, store: false) # triggers devise-jwt dispatch
            render json: user_payload(user), status: :ok
          else
            render json: { errors: ["Invalid email or password"] }, status: :unauthorized
          end
        end

        # DELETE /api/v1/auth/sign_out
        def destroy
          sign_out(resource_name)
          head :no_content
        end

        private

        def user_payload(user)
          { user: { id: user.id, email: user.email } }
        end

        def email
          params.dig(:user, :email)
        end

        def password
          params.dig(:user, :password)
        end
      end
    end
  end
end
