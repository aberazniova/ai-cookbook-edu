import { Card, Badge } from 'flowbite-react';
import { Link } from 'react-router-dom';
import { motion } from 'framer-motion';

import { type Recipe } from 'types/recipes';
import { defaultRecipeImageCompact } from 'utils/defaultRecipeImages';

function ViewRecipe({ recipe }: { recipe: Recipe }) {
  return (
    <motion.div
      initial={{ opacity: 0, scale: 0.95 }}
      animate={{ opacity: 1, scale: 1 }}
      className="mt-3"
    >
      <Card className="border-2 shadow-lg overflow-hidden border-sage-green">
        <div className="relative h-32 overflow-hidden">
          <img
            src={recipe.imageUrl || defaultRecipeImageCompact}
            alt={recipe.title}
            className="w-full h-full object-cover"
          />
          <div className="absolute inset-0 bg-gradient-to-t from-black/20 to-transparent"></div>
        </div>

        <div className="p-3 pb-2">
          <div className="flex items-center justify-between">
            <h4 className="font-bold">{recipe.title}</h4>
            <Badge color="success" className="text-white">
              {recipe.difficulty || 'Unknown'}
            </Badge>
          </div>
        </div>
        <div className="p-3 pt-0 space-y-3">
          <div className="flex gap-4 text-sm text-gray-600">
            <span>⏱️ {recipe.cookingTime || 0} min</span>
            <span>👥 {recipe.servings || 'N/A'} servings</span>
          </div>

          <div className="flex flex-col sm:flex-row gap-3">
            <Link to={`recipes/${recipe.id}`} className="w-full">
              <button className="w-full border border-green-500 text-green-600 hover:bg-green-50 rounded-md py-2">
                View Saved Recipe
              </button>
            </Link>
          </div>
        </div>
      </Card>
    </motion.div>
  );
}

export default ViewRecipe;
