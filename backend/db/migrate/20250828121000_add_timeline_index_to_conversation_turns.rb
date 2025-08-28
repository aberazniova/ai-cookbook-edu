class AddTimelineIndexToConversationTurns < ActiveRecord::Migration[8.0]
  def change
    add_index :conversation_turns, [:conversation_id, :created_at, :id], name: "index_conversation_turns_timeline"
  end
end
