class CreateIngredients < ActiveRecord::Migration[8.0]
  def change
    create_table :ingredients do |t|
      t.timestamps
      t.string :name, null: false
      t.belongs_to :recipe, null: false, foreign_key: true
    end
  end
end
