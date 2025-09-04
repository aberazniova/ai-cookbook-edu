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

    it "adds an artifact for the created recipe" do
      expect(Chatbot::AddArtifact).to receive(:call).with(
        kind: "recipe_created",
        data: hash_including(title: title)
      )
      call
    end

    it "returns the function response payload" do
      expect(call).to eq({
        functionResponse: {
          name: "create_recipe",
          response: {
            status: "success",
            message: "Recipe created successfully",
            data: RecipeCompactSerializer.new(Recipe.last).as_json
          }
        }
      })
    end
  end
end
