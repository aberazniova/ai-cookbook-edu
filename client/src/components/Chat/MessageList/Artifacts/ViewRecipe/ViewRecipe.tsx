import { Card } from 'flowbite-react';
import { Link } from 'react-router-dom';
import { motion } from 'framer-motion';
import { FiClock as Clock, FiUsers as Users } from 'react-icons/fi';

import { type RecipeCard } from 'types/recipes';
import { defaultRecipeImageCompact } from 'utils/defaultRecipeImages';
import DifficultyBadge from 'components/Common/DifficultyBadge/DifficultyBadge';

function ViewRecipe({ recipe }: { recipe: RecipeCard }) {
  return (
    <motion.div
      initial={{ opacity: 0, scale: 0.95 }}
      animate={{ opacity: 1, scale: 1 }}
    >
      <Card className="border border-gray-300 shadow-lg overflow-hidden">
        <div className="relative h-28 overflow-hidden">
          <img
            src={recipe.imageUrl || defaultRecipeImageCompact}
            alt={recipe.title || 'Recipe image'}
            className="w-full h-full object-cover"
          />

          <div className="absolute bottom-3 left-3">
            <DifficultyBadge difficulty={recipe.difficulty} />
          </div>
        </div>

        <div className="p-3 pb-2">
          <div className="flex items-center justify-between">
            <h4 className="font-bold text-left">{recipe.title}</h4>
            <div className="flex gap-4 text-sm text-gray-500 text-nowrap">
              <div className="flex items-center gap-1">
                <Clock className="w-4 h-4" />
                <span>{recipe.cookingTime || 0} min</span>
              </div>
              <div className="flex items-center gap-1">
                <Users className="w-4 h-4" />
                <span>{recipe.servings || 'N/A'}</span>
              </div>
            </div>
          </div>
        </div>
        <div className="p-3 pt-0 space-y-3">
          <div className="flex flex-col sm:flex-row gap-3">
            <Link to={`recipes/${recipe.id}`} className="w-full">
              <button className="w-full rounded-md py-2 bg-sage-green text-white hover:bg-sage-green-800">
                View Recipe
              </button>
            </Link>
          </div>
        </div>
      </Card>
    </motion.div>
  );
}

export default ViewRecipe;
