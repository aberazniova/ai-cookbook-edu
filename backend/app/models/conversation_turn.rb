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

  enum :role, {
    user: 0,
    model: 1
  }, prefix: true

  scope :text_messages, -> { where.not(text_content: nil) }
end
