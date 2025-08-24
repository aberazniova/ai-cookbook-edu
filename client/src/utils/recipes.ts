import { apiBaseUrl } from 'utils/api';
import { authFetch } from 'utils/authFetch';
import type { RecipeCard, Recipe } from 'types/recipes';
import camelcaseKeys from 'camelcase-keys';

export const getRecipesList = async (): Promise<RecipeCard[]> => {
  const response = await authFetch(`${apiBaseUrl}/recipes`);
  const data = await response.json().catch(() => ({}));

  if (!response.ok) {
    throw new Error(`Error fetching recipes! ${data.message || `status: ${response.status}`}`);
  }

  return camelcaseKeys(data);
};

export const getRecipe = async (id: number): Promise<Recipe> => {
  const response = await authFetch(`${apiBaseUrl}/recipes/${id}`);
  const data = await response.json().catch(() => ({}));

  if (!response.ok) {
    throw new Error(`Error fetching recipe! ${data.message || `status: ${response.status}`}`);
  }

  return camelcaseKeys(data);
};
