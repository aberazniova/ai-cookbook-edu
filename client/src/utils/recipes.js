import { apiBaseUrl } from './api';

export const getRecipesList = async () => {
  const response = await fetch(`${apiBaseUrl}/recipes`);
  const data = await response.json();

  if (!response.ok) {
    throw new Error(`Error fetching recipes! ${data.message || `status: ${response.status}`}`);
  }

  return data.recipes;
};
