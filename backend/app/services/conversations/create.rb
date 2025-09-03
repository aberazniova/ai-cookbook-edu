module Conversations
  class Create
    include Callable

    INITIAL_MESSAGE_FROM_MODEL =
      "Hello there! I'm your friendly cooking assistant, here to help you navigate the " \
      "wonderful world of recipes! 🍳 How can I assist you today?"

    def initialize(user:, with_initial_message: false)
      @user = user
      @with_initial_message = with_initial_message
    end

    def call
      conversation = user.conversations.create!

      if with_initial_message
        ConversationTurns::CreateFromTextMessage.call(
          message_content: INITIAL_MESSAGE_FROM_MODEL,
          conversation: conversation,
          role: :model
        )
      end

      conversation
    end

    private

    attr_reader :user, :with_initial_message
  end
end
