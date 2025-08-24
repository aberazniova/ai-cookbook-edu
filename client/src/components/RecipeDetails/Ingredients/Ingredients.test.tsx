import { render, screen } from '@testing-library/react';
import Ingredients from './Ingredients';
import type { Ingredient } from 'types/recipes';

const ingredients: Ingredient[] = [
  { name: 'Flour', amount: 100, unit: 'g' },
  { name: 'Eggs', amount: 2, unit: 'pcs' },
];

const baseProps = {
  ingredients,
  originalServings: 2,
  displayedServings: 2,
};

describe('Ingredients', () => {
  it('renders header', () => {
    render(<Ingredients {...baseProps} />);
    expect(screen.getByRole('heading', { name: /ingredients/i })).toBeInTheDocument();
  });

  ingredients.map((ingredient) => {
    it(`renders ${ingredient.name} amount and unit`, () => {
      render(<Ingredients {...baseProps} />);
      expect(screen.getByText(new RegExp(`${ingredient.amount} ${ingredient.unit}`, 'i'))).toBeInTheDocument();
    });

    it(`renders ${ingredient.name} name`, () => {
      render(<Ingredients {...baseProps} />);
      expect(screen.getByText(new RegExp(`${ingredient.name}`, 'i'))).toBeInTheDocument();
    });
  });

  it('shows scaled badge when displayedServings differs', () => {
    render(<Ingredients {...baseProps} displayedServings={4} />);
    expect(screen.getByText(/Scaled for 4x servings/i)).toBeInTheDocument();
  });
});
