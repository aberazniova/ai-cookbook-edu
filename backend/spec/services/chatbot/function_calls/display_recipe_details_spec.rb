require 'rails_helper'

describe Chatbot::FunctionCalls::DisplayRecipeDetails do
  let(:user) { create(:user) }
  let(:recipe) { create(:recipe) }

  subject(:call) { described_class.call(id: recipe.id, user: user) }

  before do
    allow(Pundit).to receive(:authorize).and_return(true)
    allow(RecipeCardSerializer).to receive(:new).and_call_original
    allow(Chatbot::SaveFunctionCallResults).to receive(:call)
  end

  describe '#call' do
    it 'authorizes the user' do
      expect(Pundit).to receive(:authorize).with(user, recipe, :show?)
      call
    end

    it 'serializes the recipe' do
      expect(RecipeCardSerializer).to receive(:new).with(recipe)
      call
    end

    it 'calls SaveFunctionCallResults with correct params' do
      expect(Chatbot::SaveFunctionCallResults).to receive(:call).with(
        function_call_name: 'display_recipe_details',
        artifact_kind: 'recipe_details',
        artifact_data: kind_of(Hash)
      )
      call
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
