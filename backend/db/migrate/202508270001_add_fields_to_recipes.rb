class AddFieldsToRecipes < ActiveRecord::Migration[8.0]
  def change
    add_column :recipes, :difficulty, :integer, null: false, default: 1
    add_column :recipes, :summary, :string
    add_column :recipes, :cooking_time, :integer
    add_column :recipes, :servings, :integer, limit: 2
  end
end
