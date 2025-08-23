import { Recipe } from 'types/recipes';

export type Message = {
  id: string;
  textContent: string;
  role: 'user' | 'model';
  recipe?: Recipe;
};
