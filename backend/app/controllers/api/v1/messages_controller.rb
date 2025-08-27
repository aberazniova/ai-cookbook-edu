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
    turns = conversation.conversation_turns.text_messages

    render json: turns, each_serializer: MessageSerializer
  end

  private

  def conversation
    @_conversation ||= begin
      return current_conversation if current_conversation.present?

      new_conversation = Conversations::Create.call(user: current_user, with_initial_message: true)
      cookies.encrypted[:conversation_id] = {
        value: new_conversation.id,
        httponly: true,
        secure: Rails.env.production?,
        same_site: :lax
      }

      new_conversation
    end
  end

  def current_conversation
    return @_current_conversation if defined?(@_current_conversation)

    @_current_conversation = current_user.conversations.find_by(id: conversation_id)
  end

  def conversation_id
    cookies.encrypted[:conversation_id]
  end

  def user_message
    params[:message]
  end

  def validate_user_message!
    return if user_message.present?

    render json: { message: "Message must be present." }, status: :bad_request
  end
end
