class Api::V1::RecipesController < ApplicationController
  before_action :authenticate_user!

  def index
    @recipes = user_recipes.order(created_at: :desc)
    render json: @recipes, each_serializer: RecipeCardSerializer
  end

  def show
    @recipe = user_recipes.find(params[:id])
    render json: @recipe, serializer: RecipeDetailSerializer
  end

  private

  def user_recipes
    Pundit.policy_scope!(current_user, Recipe)
  end
end
