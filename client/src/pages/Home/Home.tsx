import RecipesList from 'components/RecipesList/RecipesList';

function Home() {
  return (
    <>
      <div className="flex-1 min-w-0">
        <h1 className="text-3xl lg:text-4xl font-bold text-gray-800 dark:text-gray-100 mb-4 lg:mb-6">
          Your Recipes
        </h1>
        <RecipesList />
      </div>
    </>
  );
}

export default Home;
