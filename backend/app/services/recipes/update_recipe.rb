module Recipes
  class UpdateRecipe
    include Callable

    def initialize(recipe:, params:, user:)
      @recipe = recipe
      @params = params
      @user = user
    end

    def call
      authorise_update!

      recipe.update!(recipe_params)

      if params[:ingredients].present?
        update_ingredients
      end

      recipe
    end

    private

    attr_reader :recipe, :params, :user

    def update_ingredients
      recipe.ingredients.destroy_all
      Recipes::CreateIngredients.call(recipe: recipe, ingredients: params[:ingredients])
    end

    def recipe_params
      params.slice(:title, :instructions, :difficulty, :summary, :cooking_time, :servings)
    end

    def authorise_update!
      Pundit.authorize(user, recipe, :update?)
    end
  end
end
