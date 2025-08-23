export type RecipeCard = {
  id: number;
  title: string;
  imageUrl?: string;
};

export type Recipe = {
  id: number;
  title: string;
  imageUrl?: string;
  instructions: string;
  ingredients: string[];
};
