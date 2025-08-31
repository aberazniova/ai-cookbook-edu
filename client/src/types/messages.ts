import { Recipe, RecipeCard } from "./recipes";

export type Artifact = {
  kind: string;
  data: Recipe | RecipeCard;
};

export type Message = {
  id: string;
  textContent: string;
  role: 'user' | 'model';
};
