class IngredientSerializer < ActiveModel::Serializer
  attributes :name, :amount, :unit

  def amount
    200
  end

  def unit
    "gramm"
  end
end
