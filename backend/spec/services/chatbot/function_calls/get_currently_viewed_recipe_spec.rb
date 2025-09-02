require 'rails_helper'

describe Chatbot::FunctionCalls::GetCurrentlyViewedRecipe do
  let(:user) { create(:user) }
  let(:recipe) { create(:recipe) }

  subject(:call) { described_class.call(user: user) }

  before do
    allow(Current).to receive(:viewed_recipe_id).and_return(recipe.id)
    allow(Pundit).to receive(:authorize).and_return(true)
    allow(RecipeDetailSerializer).to receive(:new).and_call_original
    allow(Chatbot::SaveFunctionCallResults).to receive(:call)
  end

  describe '#call' do
    context 'when a recipe is currently viewed' do
      it 'authorizes the user' do
        expect(Pundit).to receive(:authorize).with(user, recipe, :show?)
        call
      end

      it 'serializes the recipe' do
        expect(RecipeDetailSerializer).to receive(:new).with(recipe)
        call
      end

      it 'saves function call results' do
        expect(Chatbot::SaveFunctionCallResults).to receive(:call).with(
          function_call_name: 'get_currently_viewed_recipe',
          response_data: kind_of(Hash)
        )
        call
      end
    end

    context 'when no recipe is currently viewed' do
      before do
        allow(Current).to receive(:viewed_recipe_id).and_return(nil)
      end

      it 'saves function call results with no recipe viewed message' do
        expect(Chatbot::SaveFunctionCallResults).to receive(:call).with(
          function_call_name: 'get_currently_viewed_recipe',
          message: 'No recipe is currently viewed'
        )
        call
      end
    end

    context 'when user is not authorized' do
      before do
        allow(Pundit).to receive(:authorize).and_raise(Pundit::NotAuthorizedError)
      end

      it 'raises Pundit::NotAuthorizedError' do
        expect { call }.to raise_error(Pundit::NotAuthorizedError)
      end
    end
  end
end
