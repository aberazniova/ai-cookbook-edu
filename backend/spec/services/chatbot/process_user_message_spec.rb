require "rails_helper"

RSpec.describe Chatbot::ProcessUserMessage do
  describe "#call" do
    subject(:call) { described_class.call(message_content: message_content, conversation: conversation) }

    let(:message_content) { "Hello, how are you?" }
    let(:conversation) { create(:conversation) }
    let(:gemini_response) { "I'm doing well, thank you for asking!" }

    before do
      allow(ConversationTurns::CreateFromTextMessage).to receive(:call)
      allow(Chatbot::GenerateResponse).to receive(:call).and_return(gemini_response)
    end

    it "returns a successful result with the gemini response" do
      result = call

      expect(result.success?).to be true
      expect(result.response_message).to eq(gemini_response)
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

    it "generates a response using the conversation" do
      call

      expect(Chatbot::GenerateResponse).to have_received(:call).with(
        conversation: conversation
      )
    end

    context "when an error occurs" do
      before do
        allow(Chatbot::GenerateResponse).to receive(:call).and_raise(StandardError.new("API Error"))
        allow(Rails.logger).to receive(:error)
      end

      it "returns a failed result with the error message" do
        result = call

        expect(result.success?).to be false
        expect(result.response_message).to be_nil
        expect(result.error).to eq("API Error")
      end

      it "logs the error" do
        call

        expect(Rails.logger).to have_received(:error).with("Error generating chatbot response: API Error")
      end
    end
  end
end
