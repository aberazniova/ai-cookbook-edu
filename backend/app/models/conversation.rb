# == Schema Information
#
# Table name: conversations
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer          not null
#
# Indexes
#
#  index_conversations_on_user_id  (user_id)
#

class Conversation < ApplicationRecord
  belongs_to :user

  has_many :conversation_turns, dependent: :destroy
end
