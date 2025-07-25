require "rails_helper"

RSpec.describe Chatbot::ProcessFunctionCall do
  describe "#call" do
    subject(:call) { described_class.call(function_call_name: function_call_name, function_call_args: function_call_args, conversation: conversation) }

    let(:function_call_name) { "create_recipe" }
    let(:function_call_args) { { "title" => "Test Recipe", "ingredients" => ["Ingredient 1"], "instructions" => "Test instructions" } }
    let(:conversation) { create(:conversation) }
    let(:function_result) { { "status" => "success", "message" => "Recipe saved successfully" } }
    let(:gemini_response) { "Recipe created successfully!" }

    before do
      allow(Chatbot::FunctionCalls::CreateRecipe).to receive(:call).and_return(function_result)
      allow(ConversationTurns::CreateFromFunctionResponse).to receive(:call)
      allow(Chatbot::GenerateResponse).to receive(:call).and_return(gemini_response)
    end

    it "calls the corresponding function call service with the arguments passed" do
      call

      expect(Chatbot::FunctionCalls::CreateRecipe).to have_received(:call).with(
        title: "Test Recipe",
        ingredients: ["Ingredient 1"],
        instructions: "Test instructions"
      )
    end

    it "creates a conversation turn with the function response" do
      expected_function_response = {
        name: function_call_name,
        response: function_result
      }

      call

      expect(ConversationTurns::CreateFromFunctionResponse).to have_received(:call).with(
        function_call_name: function_call_name,
        function_response_part: expected_function_response,
        conversation: conversation
      )
    end

    it "generates a response using the conversation" do
      call

      expect(Chatbot::GenerateResponse).to have_received(:call).with(
        conversation: conversation
      )
    end

    it "returns the gemini response" do
      expect(call).to eq(gemini_response)
    end

    context "when function call name is not supported" do
      let(:function_call_name) { "unsupported_function" }

      it "raises an error" do
        expect { call }.to raise_error("Function call not supported: unsupported_function")
      end
    end
  end
end
