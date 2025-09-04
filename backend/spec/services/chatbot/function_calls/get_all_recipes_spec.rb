require 'rails_helper'

RSpec.describe Chatbot::FunctionCalls::GetAllRecipes do
  describe '#call' do
    subject(:call) { described_class.call(user: user) }

    let(:user) { create(:user) }

    context 'when there are no recipes' do
      it "returns function response payload with no recipes found" do
        expect(call).to eq({
          functionResponse: {
            name: "get_all_recipes",
            response: {
              status: "success",
              data: []
            }
          }
        })
      end
    end

    context 'when there are recipes' do
      let!(:recipe1) { create(:recipe, title: 'Recipe 1', user: user) }
      let!(:recipe2) { create(:recipe, title: 'Recipe 2', user: user) }
      let!(:other_user_recipe) { create(:recipe, title: 'Other Recipe', user: create(:user)) }

      it "returns function response payload with user recipes details" do
        expected_recipes_details = ActiveModelSerializers::SerializableResource.new(
          [recipe1, recipe2],
          each_serializer: RecipeDetailSerializer
        ).as_json

        expect(call).to eq({
          functionResponse: {
            name: "get_all_recipes",
            response: {
              status: "success",
              data: expected_recipes_details
            }
          }
        })
      end
    end
  end
end
