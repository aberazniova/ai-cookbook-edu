import { useEffect, useState } from 'react';
import { Link, useParams } from 'react-router-dom';
import {
  FiArrowLeft as ArrowLeft,
  FiEdit as Edit,
} from 'react-icons/fi';

import RecipeDetails from 'components/RecipeDetails/RecipeDetails';
import { getRecipe } from 'utils/recipes';
import { useAlertStore } from 'stores/alertStore';
import Skeleton from './Skeleton/Skeleton';
import { useRecipesStore } from 'stores/recipesStore';

function Recipe() {
  const { id } = useParams<{ id: string }>();
  const [loading, setLoading] = useState(true);

  const { setCurrentRecipe, currentRecipe } = useRecipesStore();
  const addAlert = useAlertStore((state) => state.addAlert);

  const handleEdit = () => {
    addAlert({
      type: 'info',
      message: 'Manual edits are not available yet 😊. Please use the AI Assistant to edit the recipe.',
    });
  };

  useEffect(() => {
    const fetchRecipe = async () => {
      try {
        setLoading(true);
        const recipe = await getRecipe(parseInt(id));

        setCurrentRecipe(recipe);
      } catch (error) {
        addAlert({
          type: 'failure',
          message: error.message || 'Failed to load recipe.',
        });
      } finally {
        setLoading(false);
      }
    };

    fetchRecipe();

    return () => {
      setCurrentRecipe(null);
    };
  }, [id, addAlert, setCurrentRecipe]);

  if (loading) {
    return (
      <Skeleton />
    )
  }

  if (!currentRecipe) {
    return (
      <div className="min-h-screen p-6 md:p-8 flex items-center justify-center bg-cream">
        <div className="text-center">
          <h2 className="text-2xl font-bold text-gray-900 mb-2">Recipe not found</h2>
          <p className="text-gray-600 mb-6">The recipe you&apos;re looking for doesn&apos;t exist.</p>
          <Link to={"/"}>
            <button className="text-white px-3 py-2 rounded-md bg-sage-green">
              Back to My Recipes
            </button>
          </Link>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen p-6 md:p-8 bg-cream">
      <div className="max-w-4xl mx-auto">
        <div className="flex items-center gap-4 mb-8">
          <Link to={"/"}>
            <button
              type="button"
              className={`
                inline-flex items-center justify-center bg-white shadow-sm rounded-md border border-gray-200 p-2 h-10 w-10
                hover:bg-gray-100 focus:ring-gray-200 focus:ring text-sm font-medium
              `}
            >
              <ArrowLeft className="w-4 h-4" />
            </button>
          </Link>
          <h1 className="text-2xl font-bold text-gray-900">Recipe Details</h1>

          <div className="ml-auto flex items-center gap-3">
            <button
              type="button"
              className={`
                bg-white shadow-sm rounded-md whitespace-nowrap text-sm font-medium h-10 px-4 py-2 inline-flex items-center
                justify-center hover:bg-gray-100 focus:ring-gray-200 focus:ring border border-gray-200
              `}
              onClick={handleEdit}
            >
              <Edit className="w-4 h-4 inline-block mr-2" />
              Edit
            </button>
          </div>
        </div>

        <RecipeDetails loading={loading} recipe={currentRecipe} />
      </div>
    </div>
  );
}

export default Recipe;
