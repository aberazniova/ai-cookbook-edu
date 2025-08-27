require "rails_helper"

RSpec.describe Recipes::CreateIngredients do
  subject(:call) { described_class.new(recipe: recipe, ingredients: ingredients).call }

  let(:recipe) { create(:recipe) }
  let(:ingredients) { [{ name: "Pepper", amount: 1, unit: "tsp" }, { name: "Olive Oil", amount: 2, unit: "tbsp" }] }

  describe "#call" do
    it "creates ingredients for the recipe" do
      expect {
        call
      }.to change { recipe.ingredients.count }.by(ingredients.size)
    end

    it "sets the ingredient name" do
      call
      expect(recipe.ingredients.first.name).to eq("Pepper")
    end

    it "sets the ingredient amount" do
      call
      expect(recipe.ingredients.first.amount).to eq(1)
    end

    it "sets the ingredient unit" do
      call
      expect(recipe.ingredients.first.unit).to eq("tsp")
    end
  end
end
