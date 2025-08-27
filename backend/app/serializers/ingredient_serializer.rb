class IngredientSerializer < ActiveModel::Serializer
  attributes :name, :amount, :unit

  def amount
    object.amount.to_s
  end
end
