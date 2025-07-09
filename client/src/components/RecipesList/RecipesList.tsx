import { useEffect, useState } from 'react';

import RecipeCard from 'components/RecipesList/RecipeCard/RecipeCard';
import LoadingSpinner from 'components/Common/LoadingSpinner/LoadingSpinner';
import { getRecipesList } from 'utils/recipes';
import { type RecipeCard as RecipeCardType } from 'types/recipes';

function RecipesList() {
  const [recipes, setRecipes] = useState<RecipeCardType[]>([]);
  const [loading, setLoading] = useState(true);

  const fetchRecipes = async () => {
    try {
      setLoading(true);
      const recipes = await getRecipesList();

      setRecipes(recipes);
    } catch (err) {
      console.error('Error fetching recipes:', err.message);
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
          {recipes.map((recipe) => (
            <RecipeCard key={recipe.id} recipe={recipe} />
          ))}
        </div>
      )}
    </>
  );
}

export default RecipesList;
