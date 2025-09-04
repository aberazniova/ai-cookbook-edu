# == Schema Information
#
# Table name: ingredients
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  name       :string(255)      not null
#  recipe_id  :integer          not null
#  amount     :decimal(10, 2)
#  unit       :string(255)
#
# Indexes
#
#  index_ingredients_on_recipe_id  (recipe_id)
#

class Ingredient < ApplicationRecord
  belongs_to :recipe
end
