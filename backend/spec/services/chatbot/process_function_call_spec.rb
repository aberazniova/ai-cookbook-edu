require "rails_helper"

RSpec.describe Chatbot::ProcessFunctionCall do
  describe "#call" do
    subject(:call) { described_class.call(function_call_name: function_call_name, function_call_args: function_call_args) }

    let(:function_call_name) { "create_recipe" }
    let(:function_call_args) { { "title" => "Test Recipe", "ingredients" => ["Ingredient 1"], "instructions" => "Test instructions" } }
    let(:user) { create(:user) }
    let(:conversation) { create(:conversation, user: user) }

    before do
      allow(Current).to receive(:conversation).and_return(conversation)
      allow(Chatbot::GenerateResponse).to receive(:call)
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
          allow(function_call[:service]).to receive(:call)
        end

        it "calls the #{function_call[:name]} service" do
          call
          expected_args = function_call[:args].transform_keys(&:to_sym).merge(user: user)

          expect(function_call[:service]).to have_received(:call).with(expected_args)
        end
      end
    end

    it "triggers a response generation" do
      expect(Chatbot::GenerateResponse).to receive(:call)
      call
    end

    context "when function call name is not supported" do
      let(:function_call_name) { "unsupported_function" }

      it "saves function call result with the error response" do
        expect(Chatbot::SaveFunctionCallResults).to receive(:call).with(
          function_call_name: function_call_name,
          status: "error",
          message: "Function call not supported: #{function_call_name}"
        )

        call
      end
    end

    context "when function call service raises an error" do
      before do
        allow(Chatbot::FunctionCalls::CreateRecipe).to receive(:call).and_raise(StandardError, "Test error")
      end

      it "saves function call result with the error response" do
        expect(Chatbot::SaveFunctionCallResults).to receive(:call).with(
          function_call_name: function_call_name,
          status: "error",
          message: "Test error"
        )

        call
      end
    end
  end
end
