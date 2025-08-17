require "rails_helper"

RSpec.describe "Recipes API", type: :request do
  describe "GET /api/v1/recipes" do
    subject(:do_request) { get "/api/v1/recipes", headers: headers }

    let!(:recipe) { create(:recipe, :with_ingredients, title: "Test Recipe", instructions: "Test instructions") }

    it_behaves_like "when unauthorized"

    context "with valid access token" do
      let(:user) { create(:user) }
      let(:headers) { Devise::JWT::TestHelpers.auth_headers({ "Accept" => "application/json" }, user) }

      context "when there are no recipes" do
        it "returns a successful response" do
          do_request
          expect(response).to have_http_status(:ok)
        end

        it "returns an empty recipes array" do
          do_request
          expect(json_response).to eq([])
        end
      end

      context "when there are recipes" do
        let!(:recipe1) { create(:recipe, :with_ingredients, title: "Pasta Carbonara", created_at: 1.hour.ago, user: user) }
        let!(:recipe2) { create(:recipe, :with_ingredients, title: "Chicken Curry", created_at: 30.minutes.ago, user: user) }
        let!(:recipe3) { create(:recipe, :with_ingredients, title: "Beef Stew", created_at: 15.minutes.ago, user: user) }
        let!(:other_user_recipe) { create(:recipe, :with_ingredients, user: create(:user)) }

        it "returns a successful response" do
          do_request
          expect(response).to have_http_status(:ok)
        end

        it "returns recipes ordered by creation time descending" do
          do_request

          expected_order = [recipe3, recipe2, recipe1]
          actual_order = json_response.map { |recipe| recipe["title"] }

          expect(actual_order).to eq(expected_order.map(&:title))
        end

        it "returns recipes with correct attributes" do
          do_request

          expected_payload = {
            "id" => recipe3.id,
            "title" => recipe3.title
          }

          recipe_data = json_response.first
          expect(recipe_data).to eq(expected_payload)
        end

        it "does not return recipes owned by other users" do
          do_request

          expect(json_response.map { |r| r["id"] }).not_to include(other_user_recipe.id)
          expect(json_response.count).to eq(3)
        end
      end
    end
  end

  describe "GET /api/v1/recipes/:id" do
    subject(:do_request) { get "/api/v1/recipes/#{recipe_id}", headers: headers }
    let(:recipe_id) { recipe.id }

    let!(:recipe) { create(:recipe, :with_ingredients, title: "Test Recipe", instructions: "Test instructions") }

    it_behaves_like "when unauthorized"

    context "with valid access token" do
      let(:user) { create(:user) }
      let(:headers) { Devise::JWT::TestHelpers.auth_headers({ "Accept" => "application/json" }, user) }
      let!(:recipe) { create(:recipe, :with_ingredients, title: "Test Recipe", instructions: "Test instructions", user: user) }

      context "when recipe exists" do
        it "returns a successful response" do
          do_request
          expect(response).to have_http_status(:ok)
        end

        it "returns the recipe with the correct attributes" do
          do_request

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
        let(:recipe_id) { 999_999 }

        it "returns not found status" do
          do_request
          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end
end
