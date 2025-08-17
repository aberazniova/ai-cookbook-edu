require "rails_helper"

RSpec.describe Chatbot::FunctionCalls::CreateRecipe do
  describe "#call" do
    let(:user) { create(:user) }
    subject(:call) { described_class.call(title: title, ingredients: ingredients, instructions: instructions, user: user) }

    let(:title) { "Test Recipe" }
    let(:ingredients) { ["Ingredient 1", "Ingredient 2"] }
    let(:instructions) { "Test instructions" }

    before do
      allow(Recipes::CreateRecipe).to receive(:call).and_call_original
    end

    it "calls Recipes::CreateRecipe with correct parameters" do
      expect(Recipes::CreateRecipe).to receive(:call).with(
        title: title,
        ingredients: ingredients,
        instructions: instructions,
        user: user
      )
      call
    end

    it "creates a recipe" do
      expect { call }.to change { Recipe.count }.by(1)
    end

    it "returns success response with recipe data" do
      result = call
      recipe = Recipe.last

      expect(result).to eq({
        "status": "success",
        "message": "Recipe created successfully",
        "data": {
          id: recipe.id,
          title: recipe.title,
          instructions: recipe.instructions,
          ingredients: recipe.ingredients.map(&:name)
        }
      })
    end
  end
end
