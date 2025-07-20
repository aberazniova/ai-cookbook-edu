# == Schema Information
#
# Table name: conversation_turns
#
#  id              :integer          not null, primary key
#  conversation_id :integer          not null
#  role            :integer          not null
#  text_content    :text(65535)
#  payload         :json             not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_conversation_turns_on_conversation_id  (conversation_id)
#

class ConversationTurn < ApplicationRecord
  belongs_to :conversation

  # This limit exists for minimizing Gemini API token usage
  GEMINI_API_MAX_HISTORY_LENGTH = ENV.fetch("GEMINI_API_MAX_HISTORY_LENGTH", 10).to_i

  MAX_MESSAGES_DISPLAY_LIMIT = ENV.fetch("MAX_MESSAGES_DISPLAY_LIMIT", 50).to_i

  enum :role, {
    user: 0,
    model: 1,
    function: 2
  }, prefix: true

  scope :text_messages, -> { where.not(role: :function) }

  scope :limited_for_display, -> {
    order(created_at: :asc)
    .offset([count - MAX_MESSAGES_DISPLAY_LIMIT, 0].max)
  }
  scope :limited_for_gemini_api, -> {
    order(created_at: :asc)
    .offset([count - GEMINI_API_MAX_HISTORY_LENGTH, 0].max)
  }
end
