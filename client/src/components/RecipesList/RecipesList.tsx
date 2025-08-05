import { useEffect, useState } from 'react';

import RecipeCard from 'components/RecipesList/RecipeCard/RecipeCard';
import LoadingSpinner from 'components/Common/LoadingSpinner/LoadingSpinner';
import { getRecipesList } from 'utils/recipes';
import { type RecipeCard as RecipeCardType } from 'types/recipes';
import { useAlertStore } from 'stores/alertStore';

function RecipesList() {
  const [recipes, setRecipes] = useState<RecipeCardType[]>([]);
  const [loading, setLoading] = useState(true);

  const addAlert = useAlertStore((state) => state.addAlert);

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

  useEffect(() => {
    fetchRecipes();
  }, []);

  return (
    <>
      {loading ? (
        <div className="flex items-center justify-center h-full">
          <LoadingSpinner />
        </div>
      ) : (
        <div className="grid grid-cols-1 sm:grid-cols-1 md:grid-cols-2 lg:grid-cols-2 xl:grid-cols-3 gap-6 lg:gap-8">
          {recipes.length === 0 && (
            <div className="flex items-center justify-center h-full">
              <p className="text-gray-500">No recipes found</p>
            </div>
          )}
          {recipes?.map((recipe) => (
            <RecipeCard key={recipe.id} recipe={recipe} />
          ))}
        </div>
      )}
    </>
  );
}

export default RecipesList;
