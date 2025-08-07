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

    [
      {
        name: "create_recipe",
        args: { "title" => "Test Recipe", "ingredients" => ["Ingredient 1"], "instructions" => "Test instructions" },
        service: Chatbot::FunctionCalls::CreateRecipe
      },
      {
        name: "get_recipe",
        args: { "id" => 3 },
        service: Chatbot::FunctionCalls::GetRecipe
      },
      {
        name: "update_recipe",
        args: { "id" => 3, "title" => "Updated Recipe" },
        service: Chatbot::FunctionCalls::UpdateRecipe
      }
    ].each do |function_call|
      context "when function call name is #{function_call[:name]}" do
        let(:function_call_name) { function_call[:name] }
        let(:function_call_args) { function_call[:args] }

        before do
          allow(function_call[:service]).to receive(:call).and_return(function_result)
        end

        it "calls the #{function_call[:name]} service" do
          call
          expect(function_call[:service]).to have_received(:call).with(function_call[:args].transform_keys(&:to_sym))
        end
      end
    end

    context "when function call name is not supported" do
      let(:function_call_name) { "unsupported_function" }

      it "creates a conversation turn with the error response" do
        expected_function_response = {
          name: function_call_name,
          response: {
            status: "error",
            message: "Function call not supported: #{function_call_name}"
          }
        }

        call

        expect(ConversationTurns::CreateFromFunctionResponse).to have_received(:call).with(
          function_call_name: function_call_name,
          function_response_part: expected_function_response,
          conversation: conversation
        )
      end
    end

    context "when function call service raises an error" do
      before do
        allow(Chatbot::FunctionCalls::CreateRecipe).to receive(:call).and_raise(StandardError, "Test error")
      end

      it "creates a conversation turn with the error response" do
        expected_function_response = {
          name: function_call_name,
          response: {
            status: "error",
            message: "Test error"
          }
        }

        call

        expect(ConversationTurns::CreateFromFunctionResponse).to have_received(:call).with(
          function_call_name: function_call_name,
          function_response_part: expected_function_response,
          conversation: conversation
        )
      end
    end
  end
end
