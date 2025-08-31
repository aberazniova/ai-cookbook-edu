class RecipeDetailSerializer < RecipeCardSerializer
  attributes :instructions

  has_many :ingredients, serializer: IngredientSerializer
end
