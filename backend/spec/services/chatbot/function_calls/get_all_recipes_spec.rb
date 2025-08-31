require 'rails_helper'

RSpec.describe Chatbot::FunctionCalls::GetAllRecipes do
  describe '#call' do
    subject(:call) { described_class.call(user: user) }

    let(:user) { create(:user) }

    before do
      allow(Chatbot::SaveFunctionCallResults).to receive(:call)
    end

    context 'when there are no recipes' do
      it "saves function call results with an empty data array" do
        expect(Chatbot::SaveFunctionCallResults).to receive(:call).with(
          function_call_name: "get_all_recipes",
          response_data: []
        )

        call
      end
    end

    context 'when there are recipes' do
      let!(:recipe1) { create(:recipe, title: 'Recipe 1', user: user) }
      let!(:recipe2) { create(:recipe, title: 'Recipe 2', user: user) }
      let!(:other_user_recipe) { create(:recipe, title: 'Other Recipe', user: create(:user)) }

      it "saves function call results with user recipes details" do
        expected_recipes_details = ActiveModelSerializers::SerializableResource.new(
          [recipe1, recipe2],
          each_serializer: RecipeDetailSerializer
        ).as_json

        expect(Chatbot::SaveFunctionCallResults).to receive(:call).with(
          function_call_name: "get_all_recipes",
          response_data: expected_recipes_details
        )

        call
      end
    end
  end
end
