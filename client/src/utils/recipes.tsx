import { apiBaseUrl } from 'utils/api';
import type { RecipeCard, Recipe } from 'types/recipes';

export const getRecipesList = async (): Promise<RecipeCard[]> => {
  const response = await fetch(`${apiBaseUrl}/recipes`);
  const data = await response.json();

  if (!response.ok) {
    throw new Error(`Error fetching recipes! ${data.message || `status: ${response.status}`}`);
  }

  return data.recipes;
};

const recipeStub = {
  id: 1,
  title: 'Light Vegetable Salad with Avocado',
  imageUrl: 'https://via.placeholder.com/400x250/a8dadc/FFFFFF?text=Fresh+Salad',
  ingredients: [
    {
      name: '200 g fresh salad leaves (arugula, spinach, lettuce)',
    },
    {
      name: '1 ripe avocado, diced',
    },
    {
      name: '1 large tomato, sliced',
    },
    {
      name: '1 cucumber, sliced',
    },
    {
      name: '1/2 red onion, thinly sliced',
    },
  ],
  instructions: `**Step 1: Prepare the vegetables.**

Thoroughly wash and dry the salad leaves. Dice the avocado, tomato, cucumber, and thinly slice the red onion.

**Step 2: Prepare the dressing.**

In a small bowl, combine olive oil, lemon juice, Dijon mustard, salt, and pepper. Whisk well until smooth.

**Step 3: Assemble the salad.**

In a large salad bowl, combine the salad leaves, avocado, tomato, cucumber, and red onion.

**Step 4: Dress and serve.**

Pour the prepared dressing over the salad just before serving. Gently mix and serve immediately.

*Enjoy your meal!*`
};

export const getRecipe = async (id: number): Promise<Recipe> => {
  console.log('Getting recipe with id:', id);

  return Promise.resolve(recipeStub);
};
