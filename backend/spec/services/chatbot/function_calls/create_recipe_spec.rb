require "rails_helper"

RSpec.describe Chatbot::FunctionCalls::CreateRecipe do
  describe "#call" do
    let(:user) { create(:user) }
    subject(:call) do
      described_class.call(
        title: title,
        ingredients: ingredients,
        instructions: instructions,
        user: user,
        difficulty: :easy,
        summary: "Summary",
        cooking_time: 10,
        servings: 4
      )
    end

    let(:title) { "Test Recipe" }
    let(:ingredients) { [{ name: "Ingredient 2", amount: 2, unit: "pcs" }] }
    let(:instructions) { "Test instructions" }

    let(:expected_params) do
      {
        title: title,
        ingredients: ingredients,
        instructions: instructions,
        difficulty: :easy,
        summary: "Summary",
        cooking_time: 10,
        servings: 4
      }
    end

    before do
      allow(Recipes::CreateRecipe).to receive(:call).and_call_original
    end

    it "calls Recipes::CreateRecipe with correct parameters" do
      expect(Recipes::CreateRecipe).to receive(:call).with(
        user: user,
        params: expected_params
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
        status: "success",
        message: "Recipe created successfully",
        data: RecipeDetailSerializer.new(recipe).as_json
      })
    end
  end
end
