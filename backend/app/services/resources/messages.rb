class Resources::Messages
  include Callable

  def initialize(conversation_turns:)
    @conversation_turns = conversation_turns
  end

  def call
    conversation_turns.map do |turn|
      message(turn)
    end
  end

  private

  attr_reader :conversation_turns

  def message(conversation_turn)
    {
      textContent: conversation_turn.text_content,
      role: conversation_turn.role.to_s
    }
  end
end
