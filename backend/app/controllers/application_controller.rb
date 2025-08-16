class ApplicationController < ActionController::API
  include ActionController::MimeResponds
  include ActionController::Cookies
  include Devise::Controllers::Helpers

  respond_to :json
end
