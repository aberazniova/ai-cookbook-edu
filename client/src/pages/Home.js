import React from 'react';
import Header from '../components/Header/Header';
import RecipesList from '../components/RecipesList/RecipesList';
import Chat from '../components/Chat/Chat';

function Home() {
  return (
    <div className="min-h-screen bg-stone-50 dark:bg-neutral-950 font-sans antialiased text-gray-800 dark:text-gray-100">
      <Header />

      <div className="container mx-auto p-4 lg:p-10 flex flex-col lg:flex-row gap-8 lg:gap-6 lg:min-h-[calc(100vh-120px)]">
        <RecipesList />
        <Chat />
      </div>
    </div>
  );
}

export default Home;
