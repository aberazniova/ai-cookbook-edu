require 'rails_helper'

describe Chatbot::FunctionCalls::GetCurrentlyViewedRecipe do
  let(:user) { recipe.user }
  let(:recipe) { create(:recipe) }

  subject(:call) { described_class.call(user: user) }

  before do
    allow(Current).to receive(:viewed_recipe_id).and_return(recipe.id)
  end

  describe '#call' do
    context 'when a recipe is currently viewed' do
      it 'authorizes the user' do
        expect(Pundit).to receive(:authorize).with(user, recipe, :show?)
        call
      end

      it "returns function response payload with recipe details" do
        expect(call).to eq({
          functionResponse: {
            name: "get_currently_viewed_recipe",
            response: {
              status: "success",
              data: RecipeDetailSerializer.new(recipe).as_json
            }
          }
        })
      end
    end

    context 'when no recipe is currently viewed' do
      before do
        allow(Current).to receive(:viewed_recipe_id).and_return(nil)
      end

      it 'returns function response payload with no recipe viewed message' do
        expect(call).to eq({
          functionResponse: {
            name: "get_currently_viewed_recipe",
            response: {
              status: "success",
              message: "No recipe is currently viewed"
            }
          }
        })
      end
    end

    context 'when user is not authorized' do
      let(:user) { create(:user) }

      it 'raises Pundit::NotAuthorizedError' do
        expect { call }.to raise_error(Pundit::NotAuthorizedError)
      end
    end
  end
end
