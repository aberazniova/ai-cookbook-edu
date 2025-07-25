require "rails_helper"

RSpec.describe Chatbot::BuildPayload::ConversationHistory do
  describe "#call" do
    subject(:service) { described_class.call(conversation: conversation) }

    let(:conversation) { create(:conversation) }

    before do
      create_list(:conversation_turn, 2, conversation: conversation)
    end

    it "returns all turns payloads" do
      expect(service).to eq(conversation.conversation_turns.map(&:payload))
    end
  end
end
