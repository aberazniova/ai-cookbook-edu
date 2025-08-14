class Api::V1::MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :validate_user_message!, only: :create

  def create
    result = Chatbot::ProcessUserMessage.call(message_content: user_message, conversation: conversation)

    if result.success?
      render json: { message: result.response_message }
    else
      render json: { message: result.error }, status: :bad_request
    end
  end

  def index
    turns = conversation.conversation_turns.text_messages.limited_for_display

    render json: turns, each_serializer: MessageSerializer
  end

  private

  def conversation
    @_conversation ||= Conversation.last || Conversation.create! # TODO: Implement conversation retrieval based on the cookie
  end

  def user_message
    params[:message]
  end

  def validate_user_message!
    return if user_message.present?

    render json: { message: "Message must be present." }, status: :bad_request
  end
end
