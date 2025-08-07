module Recipes
  class UpdateRecipe
    include Callable

    def initialize(recipe:, params:)
      @recipe = recipe
      @params = params
    end

    def call
      recipe.update!(recipe_params)

      if params[:ingredients].present?
        update_ingredients
      end

      recipe
    end

    private

    attr_reader :recipe, :params

    def update_ingredients
      recipe.ingredients.destroy_all
      Recipes::CreateIngredients.call(recipe: recipe, ingredients: params[:ingredients])
    end

    def recipe_params
      params.slice(:title, :instructions)
    end
  end
end
