class CreateRecipes < ActiveRecord::Migration[8.0]
  def change
    create_table :recipes do |t|
      t.timestamps
      t.string :title, null: false
      t.text :instructions, null: false
    end
  end
end
