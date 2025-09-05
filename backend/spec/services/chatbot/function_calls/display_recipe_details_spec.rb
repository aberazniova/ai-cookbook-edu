require 'rails_helper'

describe Chatbot::FunctionCalls::DisplayRecipeDetails do
  let(:user) { recipe.user }
  let(:recipe) { create(:recipe) }

  subject(:call) { described_class.call(id: recipe.id, user: user) }

  describe '#call' do
    it 'authorizes the user' do
      expect(Pundit).to receive(:authorize).with(user, recipe, :show?)
      call
    end

    it 'adds an artifact with the recipe details' do
      expect(Chatbot::AddArtifact).to receive(:call).with(
        kind: "recipe_details",
        data: RecipeCardSerializer.new(recipe).as_json
      )
      call
    end

    it 'returns the function response payload' do
      expect(call).to eq({
        functionResponse: {
          name: "display_recipe_details",
          response: {
            status: "success",
            message: "Recipe details displayed successfully."
          }
        }
      })
    end

    context 'when user is not authorized' do
      let(:user) { create(:user) }

      it 'raises Pundit::NotAuthorizedError' do
        expect { call }.to raise_error(Pundit::NotAuthorizedError)
      end
    end
  end
end
