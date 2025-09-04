import { useEffect, useState } from 'react';

import { FiPlus as Plus } from 'react-icons/fi';
import { motion, AnimatePresence } from 'framer-motion';

import RecipeCard from 'components/RecipesList/RecipeCard/RecipeCard';
import { getRecipesList } from 'utils/recipes';
import { useAlertStore } from 'stores/alertStore';
import Skeleton from './Skeleton/Skelehon';
import { useRecipesStore } from 'stores/recipesStore';

function RecipesList() {
  const [loading, setLoading] = useState(true);

  const addAlert = useAlertStore((state) => state.addAlert);
  const { recipes, setRecipes } = useRecipesStore();

  useEffect(() => {
    const fetchRecipes = async () => {
      try {
        setLoading(true);
        const recipes = await getRecipesList();

        setRecipes(recipes);
      } catch (error) {
        addAlert({
          type: 'failure',
          message: error.message || 'Failed to load recipes.',
        });
      } finally {
        setLoading(false);
      }
    };

    fetchRecipes();

    return () => {
      setRecipes(null);
    };
  }, [addAlert, setRecipes]);

  if (loading) {
    return (
      <Skeleton />
    )
  }

  return (
    <AnimatePresence>
      {recipes.length === 0 ? (
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          className="text-center py-16"
        >
          <div className="w-24 h-24 mx-auto mb-6 rounded-full flex items-center justify-center bg-sage-green-200">
            <Plus className="w-12 h-12 text-sage-green" />
          </div>
          <h3 className="text-xl font-semibold text-gray-900 mb-2">
            You haven&apos;t created any recipes yet
          </h3>
          <p className="text-gray-600">
            Use the AI assistant to create your first recipe!
          </p>
        </motion.div>
      ) : (
        <motion.div
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          className="grid grid-cols-[repeat(auto-fit,minmax(250px,1fr))] gap-6"
        >
          {recipes.map((recipe, index) => (
            <RecipeCard recipe={recipe} key={index} />
          ))}
        </motion.div>
      )}
    </AnimatePresence>
  );
}

export default RecipesList;
