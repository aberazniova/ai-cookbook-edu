
class Api::V1::MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :validate_user_message!, only: :create
  before_action :set_current_context, only: :create

  def create
    result = Chatbot::ProcessUserMessage.call(message_content: user_message)

    if result.success?
      render json: {
        messages: ActiveModelSerializers::SerializableResource.new(result.messages, each_serializer: MessageSerializer),
        artifacts: result.artifacts.as_json
      }
    else
      render json: { message: result.error }, status: :bad_request
    end
  end

  def index
    turns = conversation.conversation_turns.displayable

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
        same_site: :none
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

  def set_current_context
    Current.conversation = conversation
    Current.viewed_recipe_id = params[:viewed_recipe_id]
  end
end
