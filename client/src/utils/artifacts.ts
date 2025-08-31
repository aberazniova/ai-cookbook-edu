import { Artifact } from 'types/messages';
import { setCurrentRecipe, getCurrentRecipe, getRecipes, addRecipe, updateRecipe } from 'stores/recipesStore';
import { addArtifact } from 'stores/artifactsStore';
import { Recipe, RecipeCard } from 'types/recipes';

const handleRecipeCreated = (artifact: Artifact) => {
  addArtifact(artifact);

  if (getRecipes()) {
    addRecipe(artifact.data as RecipeCard);
  }
};

const handleRecipeUpdated = (artifact: Artifact) => {
  if (getCurrentRecipe()?.id === artifact.data.id) {
    setCurrentRecipe(artifact.data as Recipe);
  } else {
    addArtifact(artifact);

    if (getRecipes()) {
      updateRecipe(artifact.data as RecipeCard);
    }
  }
};

export const handleNewArtifact = (artifact: Artifact) => {
  if (artifact.kind === 'recipe_created') {
    handleRecipeCreated(artifact);
  } else if (artifact.kind === 'recipe_updated') {
    handleRecipeUpdated(artifact);
  }
};
