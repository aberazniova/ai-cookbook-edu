class AddAmountAndUnitToIngredients < ActiveRecord::Migration[8.0]
  def change
    add_column :ingredients, :amount, :decimal, precision: 10, scale: 2
    add_column :ingredients, :unit, :string
  end
end
