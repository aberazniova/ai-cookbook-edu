require 'rails_helper'

RSpec.describe Chatbot::FunctionCalls::GetRecipe do
  describe '#call' do
    subject(:call) { described_class.call(id: recipe_id) }

    context 'when the recipe exists' do
      let(:recipe) { create(:recipe) }
      let(:recipe_id) { recipe.id }
      let(:recipe_detail) do
        {
          id: recipe.id,
          title: recipe.title,
          instructions: recipe.instructions,
          ingredients: recipe.ingredients.map(&:name)
        }
      end

      before do
        allow(Resources::RecipeDetail).to receive(:call).with(recipe).and_return(recipe_detail)
      end

      it 'calls Resources::RecipeDetail with the found recipe' do
        call
        expect(Resources::RecipeDetail).to have_received(:call).with(recipe)
      end

      it 'returns a success status and the recipe data' do
        expect(call).to eq(
          {
            "status": "success",
            "data": recipe_detail
          }
        )
      end
    end

    context 'when the recipe is not found' do
      let(:recipe_id) { -1 }

      it 'returns an error status and message' do
        expect(call).to eq(
          {
            "status": "error",
            "message": "Couldn't find Recipe with 'id'=-1"
          }
        )
      end
    end
  end
end
