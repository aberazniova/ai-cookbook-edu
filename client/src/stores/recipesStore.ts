import { create } from 'zustand';
import { combine } from 'zustand/middleware';

import type { Recipe, RecipeCard } from 'types/recipes';

type RecipesStoreState = {
  recipes: RecipeCard[] | null;
  currentRecipe: Recipe | null;
};

type RecipesStoreActions = {
  addRecipe: (recipe: RecipeCard) => void;
  updateRecipe: (recipe: RecipeCard) => void;
  setRecipes: (recipes: RecipeCard[]) => void;
  setCurrentRecipe: (recipe: Recipe) => void;
};

type RecipesStore = RecipesStoreState & RecipesStoreActions;

export const useRecipesStore = create<RecipesStore>(
  combine({ recipes: null, currentRecipe: null }, (set) => {
    return {
      addRecipe: (recipe: RecipeCard) => {
        set((state) => ({
          recipes: [recipe, ...(state.recipes || [])],
        }))
      },
      updateRecipe: (recipe: RecipeCard) => {
        set((state) => ({
          recipes: state.recipes?.map((r) => (r.id === recipe.id ? recipe : r)) || [],
        }))
      },
      setRecipes: (recipes: RecipeCard[]) => {
        set(() => ({
          recipes,
        }))
      },
      setCurrentRecipe: (recipe: Recipe) => {
        set(() => ({
          currentRecipe: recipe,
        }))
      },
    }
  }),
);

export const addRecipe = (recipe: RecipeCard) => useRecipesStore.getState().addRecipe(recipe);
export const updateRecipe = (recipe: RecipeCard) => useRecipesStore.getState().updateRecipe(recipe);
export const setCurrentRecipe = (recipe: Recipe) => useRecipesStore.getState().setCurrentRecipe(recipe);
export const getCurrentRecipe = () => useRecipesStore.getState().currentRecipe;
export const getRecipes = () => useRecipesStore.getState().recipes;
