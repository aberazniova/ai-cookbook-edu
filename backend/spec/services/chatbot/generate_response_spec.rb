require "rails_helper"

RSpec.describe Chatbot::GenerateResponse do
  describe "#call" do
    subject(:call) { described_class.call(conversation: conversation) }

    let(:conversation) { create(:conversation) }
    let(:conversation_contents) { [{ "role" => "user", "parts" => [{ "text" => "Hello" }] }] }
    let(:api_response) do
      {
        "candidates" => [
          {
            "content" => {
              "parts" => [
                {
                  "text" => "Hello! How can I help you today?"
                }
              ]
            }
          }
        ]
      }
    end

    before do
      allow(Chatbot::BuildPayload::ConversationHistory).to receive(:call).and_return(conversation_contents)
      allow(ExternalApi::GoogleGemini).to receive(:generate_content).and_return(api_response)
    end

    it "calls Chatbot::BuildPayload::ConversationHistory with the conversation" do
      call

      expect(Chatbot::BuildPayload::ConversationHistory).to have_received(:call).with(
        conversation: conversation
      )
    end

    it "calls ExternalApi::GoogleGemini.generate_content with the conversation contents" do
      call

      expect(ExternalApi::GoogleGemini).to have_received(:generate_content).with(conversation_contents)
    end

    it "saves the response turn" do
      expect { call }.to change(ConversationTurn, :count).by(1)
    end

    context "when the API response contains a text response" do
      it "returns the text response from the API" do
        expect(call).to eq("Hello! How can I help you today?")
      end
    end

    context "when the API response contains a function call" do
      let(:api_response) do
        {
          "candidates" => [
            {
              "content" => {
                "parts" => [
                  {
                    "functionCall" => {
                      "name" => "create_recipe",
                      "args" => {
                        "title" => "Test Recipe",
                        "ingredients" => ["Ingredient 1"],
                        "instructions" => "Test instructions"
                      }
                    }
                  }
                ]
              }
            }
          ]
        }
      end
      let(:function_call_result) { { "status" => "success", "message" => "Recipe created successfully!" } }

      before do
        allow(Chatbot::ProcessFunctionCall).to receive(:call).and_return(function_call_result)
      end

      it "calls ProcessFunctionCall with the correct parameters" do
        call

        expect(Chatbot::ProcessFunctionCall).to have_received(:call).with(
          function_call_name: "create_recipe",
          function_call_args: {
            "title" => "Test Recipe",
            "ingredients" => ["Ingredient 1"],
            "instructions" => "Test instructions"
          },
          conversation: conversation
        )
      end

      it "returns the result of the function call" do
        expect(call).to eq(function_call_result)
      end
    end

    context "when no response content is received" do
      let(:api_response) do
        {
          "candidates" => [
            {
              "content" => {
                "parts" => []
              }
            }
          ]
        }
      end

      it "returns nil" do
        expect(call).to be_nil
      end
    end

    context "when external API raises an error" do
      before do
        allow(ExternalApi::GoogleGemini).to receive(:generate_content).and_raise(StandardError, "API error")
      end

      it "raises an error" do
        expect { call }.to raise_error("API error")
      end
    end
  end
end
