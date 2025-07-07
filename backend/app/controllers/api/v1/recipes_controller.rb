class Api::V1::RecipesController < ApplicationController
  def index
    @recipes = Recipe.all
    render json: Resources::RecipesList.call(@recipes)
  end
end
