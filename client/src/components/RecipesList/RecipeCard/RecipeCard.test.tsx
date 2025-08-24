import { screen } from '@testing-library/react';
import { renderWithRouter } from 'utils/testUtils';
import RecipeCard from './RecipeCard';
import { recipeCardFixture as recipe } from 'utils/testFixtures';

const baseProps = { recipe };

describe('RecipeCard', () => {
  it('renders recipe title', () => {
    renderWithRouter(<RecipeCard {...baseProps} />);
    expect(screen.getByText('Classic Pasta')).toBeInTheDocument();
  });

  it('renders recipe summary', () => {
    renderWithRouter(<RecipeCard {...baseProps} />);
    expect(screen.getByText(/tasty and simple/i)).toBeInTheDocument();
  });

  it('renders recipe difficulty', () => {
    renderWithRouter(<RecipeCard {...baseProps} />);
    expect(screen.getByText(/easy/i)).toBeInTheDocument();
  });

  it('renders recipe cooking time', () => {
    renderWithRouter(<RecipeCard {...baseProps} />);
    expect(screen.getByText(/30 min/i)).toBeInTheDocument();
  });

  it('renders author line', () => {
    renderWithRouter(<RecipeCard {...baseProps} />);
    expect(screen.getByText(/By Alice/)).toBeInTheDocument();
  });

  it('links to recipe details page', () => {
    renderWithRouter(<RecipeCard {...baseProps} />);
    const link = screen.getByRole('link');
    expect(link.getAttribute('href')).toContain('recipes/1');
  });
});
