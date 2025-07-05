import RecipeCard from './RecipeCard/RecipeCard';

function RecipesList() {
  const recipes = [
    { id: 1, name: 'Fresh Avocado and Quinoa Salad', imageUrl: 'https://via.placeholder.com/300x200/a8dadc/FFFFFF?text=Salad' },
    { id: 2, name: 'Baked Salmon with Lemon and Rosemary', imageUrl: 'https://via.placeholder.com/300x280/e63946/FFFFFF?text=Salmon' },
    { id: 3, name: 'Vegetarian Lasagna with Ricotta and Spinach', imageUrl: 'https://via.placeholder.com/300x160/457b9d/FFFFFF?text=Lasagna' },
    { id: 4, name: 'Berry Smoothie Bowl with Granola and Chia', imageUrl: 'https://via.placeholder.com/300x240/f4a261/FFFFFF?text=Smoothie' },
    { id: 5, name: 'Teriyaki Chicken with Rice and Vegetables', imageUrl: 'https://via.placeholder.com/300x300/2a9d8f/FFFFFF?text=Chicken' },
    { id: 6, name: 'Coffee Dessert with Chocolate Chips and Nuts', imageUrl: 'https://via.placeholder.com/300x180/264653/FFFFFF?text=Coffee' },
    { id: 7, name: 'Creamy Tomato Soup with Basil and Croutons', imageUrl: 'https://via.placeholder.com/300x220/e76f51/FFFFFF?text=Soup' },
    { id: 8, 'name': 'Pancakes with Maple Syrup and Berries', imageUrl: 'https://via.placeholder.com/300x260/efc6b8/FFFFFF?text=Pancakes' },
    { id: 9, name: 'Vegetable Curry', imageUrl: 'https://via.placeholder.com/300x200/606c38/FFFFFF?text=Vegetable+Curry' },
    { id: 10, name: 'Greek Salad', imageUrl: 'https://via.placeholder.com/300x180/bc6c25/FFFFFF?text=Greek+Salad' },
    { id: 11, name: 'Mushroom Risotto', imageUrl: 'https://via.placeholder.com/300x210/dda15e/FFFFFF?text=Risotto' },
    { id: 12, name: 'Carrot Cake', imageUrl: 'https://via.placeholder.com/300x250/fefae0/FFFFFF?text=Cake' },
    { id: 13, name: 'Cream of Mushroom Soup', imageUrl: 'https://via.placeholder.com/300x190/283618/FFFFFF?text=Mushroom+Soup' },
    { id: 14, name: 'Lemon Pie', imageUrl: 'https://via.placeholder.com/300x230/d4a373/FFFFFF?text=Pie' },
  ];

  return (
    <div className="flex-1 min-w-0" >
      <h1 className="text-3xl lg:text-4xl font-bold text-gray-800 dark:text-gray-100 mb-4 lg:mb-6">Your Recipes</h1>

      <div className="grid grid-cols-1 sm:grid-cols-1 md:grid-cols-2 lg:grid-cols-2 xl:grid-cols-3 gap-6 lg:gap-8">
        {recipes.map((recipe) => (
          <RecipeCard key={recipe.id} recipe={recipe} />
        ))}
      </div>
    </div >
  );
}

export default RecipesList;
