import { useEffect, useState } from 'react';

import RecipeCard from 'components/RecipesList/RecipeCard/RecipeCard';
import { getRecipesList } from 'utils/recipes';
import { type RecipeCard as RecipeCardType } from 'types/recipes';

function RecipesList() {
  const [recipes, setRecipes] = useState<RecipeCardType[]>([]);
  const [loading, setLoading] = useState(false);

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
    <div className="flex-1 min-w-0" >
      <h1 className="text-3xl lg:text-4xl font-bold text-gray-800 dark:text-gray-100 mb-4 lg:mb-6">Your Recipes</h1>

      <div className="grid grid-cols-1 sm:grid-cols-1 md:grid-cols-2 lg:grid-cols-2 xl:grid-cols-3 gap-6 lg:gap-8">
        {loading ? (
          <p>Loading...</p>
        ) : (
          recipes.map((recipe) => (
            <RecipeCard key={recipe.id} recipe={recipe} />
          ))
        )}
      </div>
    </div >
  );
}

export default RecipesList;
