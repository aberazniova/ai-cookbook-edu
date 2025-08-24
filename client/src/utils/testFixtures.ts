import type { Recipe, RecipeCard } from 'types/recipes';

export const recipeFixture: Recipe = {
  id: 1,
  title: 'Avocado Toast',
  imageUrl: '',
  instructions: 'Mix and toast.\n\nEnjoy!',
  ingredients: [
    { name: 'Avocado', amount: 1, unit: 'pc' },
    { name: 'Bread', amount: 2, unit: 'slices' },
  ],
  difficulty: 'medium',
  summary: 'Simple breakfast.',
  cookingTime: 10,
  servings: 1,
  createdBy: 'Chef',
  createdDate: '2025-08-01',
};

export const recipeCardFixture: RecipeCard = {
  id: 1,
  title: 'Classic Pasta',
  imageUrl: '',
  difficulty: 'easy',
  summary: 'Tasty and simple.',
  cookingTime: 30,
  servings: 2,
  createdBy: 'Alice',
  createdDate: '2025-08-01',
};
