import { apiBaseUrl } from 'utils/api';
import type { RecipeCard, Recipe } from 'types/recipes';

export const getRecipesList = async (): Promise<RecipeCard[]> => {
  const response = await fetch(`${apiBaseUrl}/recipes`);
  const data = await response.json();

  if (!response.ok) {
    throw new Error(`Error fetching recipes! ${data.message || `status: ${response.status}`}`);
  }

  return data;
};

export const getRecipe = async (id: number): Promise<Recipe> => {
  const response = await fetch(`${apiBaseUrl}/recipes/${id}`);
  const data = await response.json();

  if (!response.ok) {
    throw new Error(`Error fetching recipe! ${data.message || `status: ${response.status}`}`);
  }

  return data;
};
