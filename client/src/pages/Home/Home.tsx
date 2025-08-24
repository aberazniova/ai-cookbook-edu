import RecipesList from 'components/RecipesList/RecipesList';

function Home() {
  return (
    <div className="min-h-full p-6 md:p-8 bg-cream">
      <div className="max-w-7xl mx-auto">
        <div className="flex flex-col mb-8 text-left">
          <h1 className="text-3xl md:text-4xl font-bold text-gray-900 mb-2">
            My Recipe Collection
          </h1>
          <p className="text-gray-600">
            Your personal collection of culinary creations
          </p>
        </div>

        <RecipesList />
      </div>
    </div>
  );
}

export default Home;
