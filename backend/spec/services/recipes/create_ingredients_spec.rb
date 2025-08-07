require "rails_helper"

RSpec.describe Recipes::CreateIngredients do
  subject(:call) { described_class.new(recipe: recipe, ingredients: ingredients).call }

  let(:recipe) { create(:recipe) }
  let(:ingredients) { ["Salt", "Pepper", "Olive Oil"] }

  describe "#call" do
    it "creates ingredients for the recipe" do
      expect {
        call
      }.to change { recipe.ingredients.count }.by(ingredients.size)
    end

    it "creates ingredient records with correct names" do
      call

      expect(recipe.ingredients.pluck(:name)).to match_array(ingredients)
    end
  end
end
