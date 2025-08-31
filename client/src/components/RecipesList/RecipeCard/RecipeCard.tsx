import { motion } from 'framer-motion';
import { Card } from 'flowbite-react';
import { FiClock as Clock, FiUsers as Users } from 'react-icons/fi';
import { Link } from 'react-router-dom';

import { type RecipeCard as RecipeCardType } from 'types/recipes';
import { defaultRecipeImageCompact } from 'utils/defaultRecipeImages';
import DifficultyBadge from 'components/Common/DifficultyBadge/DifficultyBadge';

function RecipeCard({ recipe }: { recipe: RecipeCardType }) {
  return (
    <motion.div
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      whileHover={{ y: -5 }}
      transition={{ duration: 0.3 }}
      className="h-full"
    >
      <Link to={`recipes/${recipe.id}`} className="h-full block">
        <Card className="overflow-hidden bg-white hover:shadow-xl transition-all duration-300 border-0 shadow-md flex flex-col h-full text-left">
          <div className="relative h-48 overflow-hidden">
            <img
              src={recipe.imageUrl || defaultRecipeImageCompact}
              alt={recipe.title || 'Recipe image'}
              className="w-full h-full object-cover transition-transform duration-300 hover:scale-110"
            />

            <div className="absolute bottom-3 left-3">
              <DifficultyBadge difficulty={recipe.difficulty} />
            </div>
          </div>

          <div className="p-5 flex-1 flex flex-col">
            <div className="flex flex-col flex-1 space-y-3 justify-between">
              <h3 className="font-bold text-lg text-gray-900 leading-tight line-clamp-2">
                {recipe.title}
              </h3>

              <p className="text-gray-600 text-sm leading-relaxed line-clamp-3">
                {recipe.summary || 'No summary available.'}
              </p>

              <div className="flex items-center gap-4 text-sm text-gray-500 pt-2">
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

          <div className="px-5 py-3 bg-gray-50/50 border-t border-gray-100 mt-auto">
            <div className="flex items-center justify-between gap-2 text-xs text-gray-500 w-full">
              <span className="truncate">By {recipe.createdBy || 'Anonymous'}</span>
              <span></span>
              <span className="whitespace-nowrap">{recipe.createdDate}</span>
            </div>
          </div>
        </Card>
      </Link>
    </motion.div>
  );
}

export default RecipeCard;
