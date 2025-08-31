import { screen } from '@testing-library/react';
import { renderWithRouter } from 'utils/testUtils';
import ViewRecipe from './ViewRecipe';
import { recipeCardFixture } from 'utils/testFixtures';

describe('ViewRecipe', () => {
  it('renders recipe title', () => {
    renderWithRouter(<ViewRecipe recipe={recipeCardFixture} />);
    expect(screen.getByText('Classic Pasta')).toBeInTheDocument();
  });

  it('renders cooking time and servings', () => {
    renderWithRouter(<ViewRecipe recipe={recipeCardFixture} />);

    expect(screen.getByText('30 min')).toBeInTheDocument();
    expect(screen.getByText('2')).toBeInTheDocument();
  });

  it('renders difficulty badge', () => {
    renderWithRouter(<ViewRecipe recipe={recipeCardFixture} />);
    expect(screen.getByText(/easy/i)).toBeInTheDocument();
  });

  it('renders default image if imageUrl is missing', () => {
    renderWithRouter(<ViewRecipe recipe={{ ...recipeCardFixture, imageUrl: '' }} />);
    const image = screen.getByAltText('Classic Pasta') as HTMLImageElement;

    expect(image).toBeInTheDocument();
    expect(image.src).toContain('default-recipe-compact');
  });

  it('renders custom image if imageUrl is provided', () => {
    renderWithRouter(<ViewRecipe recipe={{ ...recipeCardFixture, imageUrl: 'custom.jpg' }} />);
    const image = screen.getByAltText('Classic Pasta') as HTMLImageElement;

    expect(image).toBeInTheDocument();
    expect(image.src).toContain('custom.jpg');
  });

  it('renders link to recipe details', () => {
    renderWithRouter(<ViewRecipe recipe={recipeCardFixture} />);

    const link = screen.getByRole('link', { name: /view recipe/i });
    expect(link).toHaveAttribute('href', '/recipes/1');
  });
});
