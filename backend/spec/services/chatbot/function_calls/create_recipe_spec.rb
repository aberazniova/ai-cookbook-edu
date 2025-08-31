require "rails_helper"

RSpec.describe Chatbot::FunctionCalls::CreateRecipe do
  describe "#call" do
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

    let(:user) { create(:user) }
    let(:title) { "Test Recipe" }
    let(:ingredients) { [{ name: "Ingredient 1", amount: 2, unit: "pcs" }] }
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
      allow(Chatbot::SaveFunctionCallResults).to receive(:call)
    end

    it "creates a new recipe" do
      expect { call }.to change { Recipe.count }.by(1)
    end

    it "creates a recipe with the correct arguments" do
      call

      recipe = Recipe.last
      expect(recipe.title).to eq(title)
      expect(recipe.ingredients.pluck(:name)).to eq(["Ingredient 1"])
      expect(recipe.instructions).to eq(instructions)
      expect(recipe.difficulty).to eq("easy")
      expect(recipe.summary).to eq("Summary")
      expect(recipe.cooking_time).to eq(10)
      expect(recipe.servings).to eq(4)
    end

    it "saves the function call results" do
      call

      recipe = Recipe.last

      expect(Chatbot::SaveFunctionCallResults).to have_received(:call).with(
        function_call_name: "create_recipe",
        response_data: RecipeCompactSerializer.new(recipe).as_json,
        message: "Recipe created successfully",
        artifact_kind: "recipe_created",
        artifact_data: RecipeCardSerializer.new(recipe).as_json
      )
    end
  end
end
