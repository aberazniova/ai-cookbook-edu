class RecipeDetailSerializer < ActiveModel::Serializer
  attributes :id, :title, :instructions
  has_many :ingredients
end
