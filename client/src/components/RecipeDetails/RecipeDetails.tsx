import { useEffect, useState } from 'react';
import { useParams } from 'react-router-dom';

import { Card } from 'flowbite-react';
import ReactMarkdown from 'react-markdown';

import LoadingSpinner from 'components/Common/LoadingSpinner/LoadingSpinner';

import { getRecipe } from 'utils/recipes';
import { type Recipe } from 'types/recipes';

function RecipeDetails() {
  const { id } = useParams<{ id: string }>();
  const [recipe, setRecipe] = useState<Recipe>();
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchRecipe = async () => {
      try {
        setLoading(true);
        const recipe = await getRecipe(parseInt(id, 10));

        setRecipe(recipe);
      } catch (err) {
        console.error('Error fetching recipe:', err.message);
      } finally {
        setLoading(false);
      }
    };

    fetchRecipe();
  }, [id]);

  return (
    <Card
      className="flex-1 min-w-0 max-w-full lg:max-w-none transform transition-all duration-300 hover:shadow-xl
                     bg-white dark:bg-neutral-800 border border-stone-100 dark:border-neutral-700
                     rounded-2xl overflow-hidden shadow-lg p-0 text-left"
    >
      {loading ? (
        <LoadingSpinner />
      ) : (
        <div className="flex flex-col justify-start h-full">
          {recipe.imageUrl && (
            <img
              src={recipe.imageUrl}
              alt={recipe.title || 'Recipe image'}
              className="rounded-t-2xl object-cover w-full h-56 sm:h-64 lg:h-72"
            />
          )}
          <div className="py-1 lg:py-2 px-2 lg:px-3 prose prose-gray dark:prose-invert prose-p:text-gray-700 dark:prose-p:text-gray-200
            prose-strong:text-gray-900 dark:prose-strong:text-gray-100 max-w-none text-base
            lg:text-lg prose-p:mb-3 prose-p:mt-0 leading-relaxed prose-ul:pl-4">
            <h5 className="text-2xl sm:text-3xl lg:text-4xl font-bold tracking-tight text-gray-900 dark:text-gray-50 text-center">
              {recipe.title}
            </h5>

            <div>
              <h2 className="text-xl lg:text-2xl font-semibold text-gray-800 dark:text-gray-100">
                Ingredients
              </h2>
              <ul className="list-disc list-inside text-gray-700 dark:text-gray-200 text-base lg:text-lg space-y-1">
                {recipe.ingredients.map((ingredient, index) => (
                  <li key={index}>{ingredient.name}</li>
                ))}
              </ul>
            </div>

            <div>
              <h2 className="text-xl lg:text-2xl font-semibold text-gray-800 dark:text-gray-100">
                Instructions
              </h2>
              <ReactMarkdown>
                {recipe.instructions}
              </ReactMarkdown>
            </div>
          </div>
        </div>
      )}
    </Card>
  );
}

export default RecipeDetails;
