require "rails_helper"

RSpec.describe Chatbot::FunctionCalls::UpdateRecipe do
  subject(:call) do
    described_class.call(
      id: recipe_id,
      title: new_title,
      ingredients: new_ingredients,
      instructions: new_instructions,
      difficulty: :easy,
      summary: "Summary",
      cooking_time: 10,
      servings: 4,
      user: user
    )
  end

  let(:user) { create(:user) }
  let(:recipe) { create(:recipe, title: "Old Title", instructions: "Old instructions", user: user) }
  let(:recipe_id) { recipe.id }

  let!(:old_ingredients) { create_list(:ingredient, 2, recipe: recipe) }
  let(:new_title) { "New Title" }
  let(:new_ingredients) { [{ name: "Salt", amount: 1, unit: "tsp" }] }
  let(:new_instructions) { "New instructions" }

  before do
    allow(Chatbot::SaveFunctionCallResults).to receive(:call)
  end

  it "updates the recipe" do
    call
    recipe.reload

    expect(recipe.title).to eq(new_title)
    expect(recipe.instructions).to eq(new_instructions)
    expect(recipe.ingredients.map(&:name)).to eq(["Salt"])
    expect(recipe.difficulty).to eq("easy")
    expect(recipe.summary).to eq("Summary")
    expect(recipe.cooking_time).to eq(10)
    expect(recipe.servings).to eq(4)
  end

  it "saves the function call results" do
    call

    expect(Chatbot::SaveFunctionCallResults).to have_received(:call).with(
      function_call_name: "update_recipe",
      response_data: RecipeCompactSerializer.new(recipe.reload).as_json,
      message: "Recipe updated successfully",
      artifact_kind: "recipe_updated",
      artifact_data: RecipeDetailSerializer.new(recipe.reload).as_json
    )
  end

  context "when only some params are provided" do
    subject(:call) { described_class.call(id: recipe.id, title: new_title, user: user) }

    it "updates only the provided fields" do
      call
      recipe.reload
      expect(recipe.title).to eq(new_title)
    end

    it "does not change the fields that are not provided" do
      call
      recipe.reload
      expect(recipe.instructions).to eq("Old instructions")
    end

    it "does not change the ingredients if not provided" do
      call
      recipe.reload
      expect(recipe.ingredients.pluck(:name)).to eq(old_ingredients.pluck(:name))
    end
  end

  context "when the recipe is not found" do
    let(:recipe_id) { -1 }

    it "raises a RecordNotFound error" do
      expect { call }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
