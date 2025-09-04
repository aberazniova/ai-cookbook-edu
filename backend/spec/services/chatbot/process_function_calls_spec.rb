require "rails_helper"

RSpec.describe Chatbot::ProcessFunctionCalls do
  describe '.call' do
    subject(:call) { described_class.call(function_calls: function_calls) }

    let(:conversation) { create(:conversation) }
    let(:function_calls) do
      [
        { 'name' => 'foo', 'args' => { 'a' => 1 } },
        { 'name' => 'bar', 'args' => { 'b' => 2 } }
      ]
    end

    before do
      allow(Chatbot::GenerateResponse).to receive(:call)
      allow(Chatbot::ProcessFunctionCall).to receive(:call).and_return('part')

      Current.conversation = conversation
    end

    after do
      Current.conversation = nil
    end

    it 'processes each function call' do
      expect(Chatbot::ProcessFunctionCall).to receive(:call).with(function_call_name: 'foo', function_call_args: { 'a' => 1 })
      expect(Chatbot::ProcessFunctionCall).to receive(:call).with(function_call_name: 'bar', function_call_args: { 'b' => 2 })

      call
    end

    it 'creates a conversation turn with the returned parts' do
      expect(ConversationTurns::CreateFromRawParts).to receive(:call).with(
        parts: ['part', 'part'],
        role: :user,
        conversation: conversation
      )

      call
    end

    it 'triggers follow up response generation' do
      expect(Chatbot::GenerateResponse).to receive(:call)

      call
    end
  end
end
