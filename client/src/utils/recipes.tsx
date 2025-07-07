import { apiBaseUrl } from 'utils/api';
import { type RecipeCard } from 'types/recipes';

export const getRecipesList = async (): Promise<RecipeCard[]> => {
  const response = await fetch(`${apiBaseUrl}/recipes`);
  const data = await response.json();

  if (!response.ok) {
    throw new Error(`Error fetching recipes! ${data.message || `status: ${response.status}`}`);
  }

  return data.recipes;
};
