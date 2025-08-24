import { Badge } from 'flowbite-react';
import { Ingredient } from 'types/recipes';

type Props = {
  ingredients: Ingredient[],
  displayedServings: number,
  originalServings: number,
};

function Ingredients({ ingredients, displayedServings, originalServings }: Props) {
  const servingMultiplier = originalServings && displayedServings && displayedServings / originalServings;

  const adjustedIngredients = ingredients?.map(ingredient => {
    if (!ingredient.amount || !servingMultiplier)
      return ingredient;

    return {
      ...ingredient,
      amount: ingredient.amount * servingMultiplier
    }
  });

  return (
    <div className="mb-8">
      <div className="flex items-center justify-between mb-4">
        <h2 className="text-xl font-bold text-gray-900">Ingredients</h2>
        {displayedServings !== originalServings && (
          <Badge className="bg-terracotta-200 hover:bg-terracotta-200 text-terracotta-600 border border-terracotta-600">
            Scaled for {displayedServings}x servings
          </Badge>
        )}
      </div>
      <div className="space-y-3">
        {adjustedIngredients?.map((ingredient, index) => (
          <div
            key={index}
            className="flex items-center gap-4 p-4 bg-gray-50 rounded-xl"
          >
            <div className="w-2 h-2 rounded-full bg-sage-green"></div>
            <div className="flex-1">
              <span className="font-medium">{ingredient.amount} {ingredient.unit}</span>
              <span className="text-gray-700 ml-2">{ingredient.name}</span>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}

export default Ingredients;
