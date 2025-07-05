import { Card } from 'flowbite-react';

function RecipeCard({ recipe }) {
  return (
    <Card
      key={recipe.id}
      href="#"
      className="max-w-sm transform transition-all duration-300 hover:scale-[1.02] hover:shadow-xl
bg-white dark:bg-neutral-800 border border-stone-100 dark:border-neutral-700
rounded-2xl overflow-hidden shadow-lg group"
    >
      <img
        src={recipe.imageUrl}
        alt={recipe.name}
        className="rounded-t-2xl object-cover w-full h-48 lg:h-56 transition-transform duration-300 group-hover:scale-105"
      />
      <div>
        <h5 className="text-xl lg:text-2xl font-semibold tracking-tight text-gray-900 dark:text-gray-50 mt-2">
          {recipe.name}
        </h5>
      </div>
    </Card>
  );
}

export default RecipeCard;
