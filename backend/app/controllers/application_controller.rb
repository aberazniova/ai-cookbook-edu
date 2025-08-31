class ApplicationController < ActionController::API
  include ActionController::MimeResponds
  include ActionController::Cookies
  include Devise::Controllers::Helpers
  include Pundit

  before_action :set_current_artifacts

  rescue_from Pundit::NotAuthorizedError do |exception|
    render json: { error: exception.message }, status: :forbidden
  end

  respond_to :json

  def set_current_artifacts
    Current.artifacts = []
  end
end
