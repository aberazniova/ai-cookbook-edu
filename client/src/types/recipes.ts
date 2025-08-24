export type RecipeCard = {
  id: number;
  title: string;
  imageUrl?: string;
  difficulty: string;
  summary: string;
  cookingTime: number;
  servings: number;
  createdBy: string;
  createdDate: string;
};

export type Recipe = {
  id: number;
  title: string;
  imageUrl?: string;
  instructions: string;
  ingredients: Ingredient[];
  difficulty: string;
  summary: string;
  cookingTime: number;
  servings: number;
  createdBy: string;
  createdDate: string;
};

export type Ingredient = {
  name: string;
  amount: number;
  unit: string;
};
