require "rails_helper"

RSpec.describe Chatbot::ProcessUserMessage do
  describe "#call" do
    subject(:call) { described_class.call(message_content: message_content) }

    let(:message_content) { "Hello, how are you?" }
    let(:conversation) { create(:conversation) }
    let(:response_messages) { build_list(:conversation_turn, 2, :model, conversation: conversation) }
    let(:user_message_turn) { build_stubbed(:conversation_turn, :user_message, conversation: conversation) }

    before do
      allow(Current).to receive(:conversation).and_return(conversation)
      allow(ConversationTurns::CreateFromTextMessage).to receive(:call).and_return(user_message_turn)
      allow(Chatbot::GenerateResponse).to receive(:call)
      allow(conversation).to receive_message_chain(:conversation_turns, :displayable, :where).and_return(response_messages)
    end

    it "returns a successful result with the response messages" do
      result = call

      expect(result.success?).to be true
      expect(result.messages).to eq(response_messages)
      expect(result.error).to be_nil
    end

    it "creates a conversation turn for the user message" do
      call

      expect(ConversationTurns::CreateFromTextMessage).to have_received(:call).with(
        message_content: message_content,
        conversation: conversation,
        role: :user
      )
    end

    it "triggers response generation" do
      expect(Chatbot::GenerateResponse).to receive(:call)

      call
    end

    context "when artifacts are present" do
      let(:artifacts) { [double("Artifact 1"), double("Artifact 2")] }

      before do
        allow(Current).to receive(:artifacts).and_return(artifacts)
      end

      it "returns the artifacts in the result" do
        expect(call.artifacts).to eq(artifacts)
      end
    end

    context "when an error occurs" do
      before do
        allow(Chatbot::GenerateResponse).to receive(:call).and_raise(StandardError.new("API Error"))
        allow(Rails.logger).to receive(:error)
      end

      it "returns a failed result with the error message" do
        result = call

        expect(result.success?).to be false
        expect(result.messages).to be_nil
        expect(result.error).to eq("API Error")
      end

      it "logs the error" do
        call

        expect(Rails.logger).to have_received(:error).with("Error generating chatbot response: API Error")
      end
    end
  end
end
