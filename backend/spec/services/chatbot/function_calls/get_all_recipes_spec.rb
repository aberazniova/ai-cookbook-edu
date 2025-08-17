require 'rails_helper'

RSpec.describe Chatbot::FunctionCalls::GetAllRecipes do
  describe '#call' do
    let(:user) { create(:user) }
    subject(:call) { described_class.call(user: user) }

    context 'when there are no recipes' do
      it 'returns a success status' do
        expect(call[:status]).to eq('success')
      end

      it 'returns an empty data array' do
        expect(call[:data]).to eq([])
      end
    end

    context 'when there are recipes' do
      let!(:recipe1) { create(:recipe, title: 'Recipe 1', user: user) }
      let!(:recipe2) { create(:recipe, title: 'Recipe 2', user: user) }
      let!(:other_user_recipe) { create(:recipe, title: 'Other Recipe', user: create(:user)) }

      it 'does not include recipes belonging to other users' do
        expect(call[:data].map { |r| r[:id] }).not_to include(other_user_recipe.id)
      end

      it 'returns a success status' do
        expect(call[:status]).to eq('success')
      end

      it 'returns all recipes' do
        expect(call[:data].count).to eq(2)
      end

      it 'returns the detailed attributes for the recipe' do
        expect(call[:data].first).to eq({
          id: recipe1.id,
          title: recipe1.title,
          ingredients: recipe1.ingredients.map(&:name),
          instructions: recipe1.instructions
        })
      end
    end
  end
end
