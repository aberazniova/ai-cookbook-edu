require "rails_helper"

RSpec.describe Api::V1::RecipesController, type: :controller do
  describe "#index" do
    subject(:do_request) { get :index }

    context "when there are no recipes" do
      it "returns a successful response" do
        do_request
        expect(response).to have_http_status(:ok)
      end

      it "returns an empty recipes array" do
        do_request
        json_response = JSON.parse(response.body)
        expect(json_response).to eq([])
      end
    end

    context "when there are recipes" do
      let!(:recipe1) { create(:recipe, :with_ingredients, title: "Pasta Carbonara", created_at: 1.hour.ago) }
      let!(:recipe2) { create(:recipe, :with_ingredients, title: "Chicken Curry", created_at: 30.minutes.ago) }
      let!(:recipe3) { create(:recipe, :with_ingredients, title: "Beef Stew", created_at: 15.minutes.ago) }

      it "returns a successful response" do
        do_request
        expect(response).to have_http_status(:ok)
      end

      it "returns recipes ordered by creation time descending" do
        do_request
        json_response = JSON.parse(response.body)

        expected_order = [recipe3, recipe2, recipe1]
        actual_order = json_response.map { |recipe| recipe["title"] }

        expect(actual_order).to eq(expected_order.map(&:title))
      end

      it "returns recipes with correct attributes" do
        do_request
        json_response = JSON.parse(response.body)

        expected_payload = {
          "id" => recipe3.id,
          "title" => recipe3.title
        }

        recipe_data = json_response.first
        expect(recipe_data).to eq(expected_payload)
      end
    end
  end

  describe "#show" do
    subject(:do_request) { get :show, params: { id: recipe.id } }

    let!(:recipe) { create(:recipe, :with_ingredients, title: "Test Recipe", instructions: "Test instructions") }

    context "when recipe exists" do
      it "returns a successful response" do
        do_request
        expect(response).to have_http_status(:ok)
      end

      it "returns the recipe with the correct attributes" do
        do_request
        json_response = JSON.parse(response.body)

        expected_payload = {
          "id" => recipe.id,
          "title" => recipe.title,
          "instructions" => recipe.instructions,
          "ingredients" => recipe.ingredients.map(&:name)
        }

        expect(json_response).to eq(expected_payload)
      end
    end

    context "when recipe does not exist" do
      subject(:do_request) { get :show, params: { id: 99999 } }

      it "returns not found status" do
        expect { do_request }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
