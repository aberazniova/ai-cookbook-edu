class CreateConversationTurns < ActiveRecord::Migration[8.0]
  def change
    create_table :conversation_turns do |t|
      t.references :conversation, null: false, foreign_key: true
      t.integer :role, null: false
      t.text :text_content
      t.json :payload, null: false

      t.timestamps
    end
  end
end
