require "rails_helper"

RSpec.describe Conversations::Create do
  describe ".call" do
    subject(:call) { described_class.call(user: user, with_initial_message: with_initial_message) }

    let(:user) { create(:user) }

    context "without initial message" do
      let(:with_initial_message) { false }

      it "creates a conversation for the user" do
        expect { call }.to change(user.conversations, :count).by(1)
      end

      it "returns the conversation associated to the user" do
        conversation = call
        expect(conversation).to eq(Conversation.last)
      end

      it "does not create any conversation turns" do
        expect { call }.not_to change(ConversationTurn, :count)
      end
    end

    context "with initial message" do
      let(:with_initial_message) { true }

      it "creates a conversation for the user" do
        expect { call }.to change(user.conversations, :count).by(1)
      end

      it "creates the initial model message with expected content and role" do
        conversation = call
        turn = conversation.conversation_turns.last
        expect(turn).to be_present
        expect(turn.role).to eq("model")
        expect(turn.text_content).to eq(described_class::INITIAL_MESSAGE_FROM_MODEL)
      end
    end
  end
end
