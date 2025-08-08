class RecipeDetailSerializer < ActiveModel::Serializer
  attributes :id, :title, :instructions, :ingredients

  def ingredients
    object.ingredients.pluck(:name)
  end
end
