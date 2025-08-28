require "rails_helper"

RSpec.describe ConversationTurns::CreateFromResponsePayload do
  describe ".call" do
    subject(:call) { described_class.call(response_payload: response_payload, conversation: conversation) }

    let(:conversation) { create(:conversation) }
    let(:response_payload) do
      {
        "parts" => [
          { "text" => "Hi there" }
        ]
      }
    end

    it "creates a new conversation turn" do
      expect { call }.to change(ConversationTurn, :count).by(1)
    end

    it "sets role to model" do
      expect(call.role).to eq("model")
    end

    it "stores payload in conversation turn" do
      expect(call.payload).to eq(response_payload)
    end

    context "with multi-part text response" do
      let(:response_payload) do
        {
          "parts" => [
            { "text" => "First" },
            { "text" => "Second" }
          ]
        }
      end

      it "concatenates all text parts into text_content" do
        turn = call
        expect(turn.text_content).to eq("First\n\nSecond")
      end
    end

    context "with mixed text and function call" do
      let(:response_payload) do
        {
          "parts" => [
            { "text" => "Reply" },
            { "functionCall" => { "name" => "create_recipe", "args" => { "title" => "T" } } }
          ]
        }
      end

      it "stores text_content from text parts" do
        expect(call.text_content).to eq("Reply")
      end

      it "preserves text content in payload" do
        expect(call.payload["parts"]).to include(include("text" => "Reply"))
      end

      it "preserves functionCall in payload" do
        expect(call.payload["parts"]).to include(include("functionCall" => include("name" => "create_recipe")))
      end
    end

    context "with thoughtSignature present" do
      let(:response_payload) do
        {
          "parts" => [
            { "text" => "Reply", "thoughtSignature" => "xxx" }
          ]
        }
      end

      it "strips thoughtSignature from stored payload" do
        expect(call.payload["parts"].first.keys).not_to include("thoughtSignature")
      end
    end
  end
end
