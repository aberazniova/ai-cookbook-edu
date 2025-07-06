import { Card } from 'flowbite-react';
import { FaLeaf } from 'react-icons/fa';

function RecipeCard({ recipe }) {
  return (
    <Card
      key={recipe.id}
      href="#"
      className="max-w-sm transform transition-all duration-300 hover:scale-[1.02] hover:shadow-xl
bg-white dark:bg-neutral-800 border border-stone-100 dark:border-neutral-700
rounded-2xl overflow-hidden shadow-lg group"
    >
      {recipe.imageUrl ? (
        <img
          src={recipe.imageUrl}
          alt={recipe.name || 'Recipe image'}
          className="rounded-t-2xl object-cover w-full h-48 lg:h-56 transition-transform duration-300 group-hover:scale-105"
        />
      ) : (
        <div className="flex items-center justify-center w-full h-48 lg:h-56 bg-emerald-100 rounded-2xl dark:bg-emerald-900">
          <FaLeaf className="w-24 h-24 text-emerald-600 dark:text-emerald-400" />
        </div>
      )}
      <div>
        <h5 className="text-xl lg:text-2xl font-semibold tracking-tight text-gray-900 dark:text-gray-50 mt-2">
          {recipe.name}
        </h5>
      </div>
    </Card>
  );
}

export default RecipeCard;
