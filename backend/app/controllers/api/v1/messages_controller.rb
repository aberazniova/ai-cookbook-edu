class Api::V1::MessagesController < ApplicationController
  before_action :validate_user_message!

  def create
    result = Chatbot::ProcessUserMessage.call(message_content: user_message)

    if result.success?
      render json: { message: result.response_message }
    else
      render json: { message: result.error }, status: :bad_request
    end
  end

  private

  def user_message
    params[:message]
  end

  def validate_user_message!
    return if user_message.present?

    render json: { message: "Message must be present." }, status: :unprocessable_entity
  end
end
