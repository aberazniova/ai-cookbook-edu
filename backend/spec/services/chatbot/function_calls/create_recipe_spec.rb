require "rails_helper"

RSpec.describe Chatbot::FunctionCalls::CreateRecipe do
  describe "#call" do
    subject(:call) { described_class.call(title: title, ingredients: ingredients, instructions: instructions) }

    let(:title) { "Test Recipe" }
    let(:ingredients) { ["Ingredient 1", "Ingredient 2"] }
    let(:instructions) { "Test instructions" }
    let(:recipe) { create(:recipe, title: title, instructions: instructions) }

    before do
      allow(Recipes::CreateRecipe).to receive(:call).and_return(recipe)
      allow(Resources::RecipeDetail).to receive(:call).with(recipe).and_return(
        {
          id: recipe.id,
          title: recipe.title,
          instructions: recipe.instructions,
          ingredients: []
        }
      )
    end

    it "calls Recipes::CreateRecipe with correct parameters" do
      call

      expect(Recipes::CreateRecipe).to have_received(:call).with(
        title: title,
        ingredients: ingredients,
        instructions: instructions
      )
    end

    it "calls Resources::RecipeDetail with the created recipe" do
      call

      expect(Resources::RecipeDetail).to have_received(:call).with(recipe)
    end

    it "returns success response with recipe data" do
      expect(call).to eq({
        "status": "success",
        "message": "Recipe created successfully",
        "data": {
          id: recipe.id,
          title: recipe.title,
          instructions: recipe.instructions,
          ingredients: []
        }
      })
    end
  end
end
