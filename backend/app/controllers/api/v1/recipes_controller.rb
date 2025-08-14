class Api::V1::RecipesController < ApplicationController
  before_action :authenticate_user!

  def index
    @recipes = Recipe.all.order(created_at: :desc)
    render json: @recipes, each_serializer: RecipeSerializer
  end

  def show
    @recipe = Recipe.find(params[:id])
    render json: @recipe, serializer: RecipeDetailSerializer
  end
end
