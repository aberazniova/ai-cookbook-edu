class Api::V1::RecipesController < ApplicationController
  def index
    @recipes = Recipe.all.order(created_at: :desc)
    render json: Resources::RecipesList.call(@recipes)
  end

  def show
    @recipe = Recipe.find(params[:id])
    render json: Resources::RecipeDetail.call(@recipe)
  end
end
