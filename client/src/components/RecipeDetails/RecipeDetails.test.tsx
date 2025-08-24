import { screen } from '@testing-library/react';
import { renderWithRouter } from 'utils/testUtils';
import RecipeDetails from './RecipeDetails';
import { recipeFixture as recipe } from 'utils/testFixtures';

const baseProps = { recipe, loading: false };

describe('RecipeDetails', () => {
  it('renders recipe title', () => {
    renderWithRouter(<RecipeDetails {...baseProps} />);
    expect(screen.getByRole('heading', { name: /avocado toast/i })).toBeInTheDocument();
  });

  it('renders summary text', () => {
    renderWithRouter(<RecipeDetails {...baseProps} />);
    expect(screen.getByText(/simple breakfast/i)).toBeInTheDocument();
  });

  it('renders Ingredients section heading', () => {
    renderWithRouter(<RecipeDetails {...baseProps} />);
    expect(screen.getByRole('heading', { name: /ingredients/i })).toBeInTheDocument();
  });

  it('renders Instructions section heading', () => {
    renderWithRouter(<RecipeDetails {...baseProps} />);
    expect(screen.getByRole('heading', { name: /instructions/i })).toBeInTheDocument();
  });

  it('displays the upload button', () => {
    renderWithRouter(<RecipeDetails {...baseProps} />);
    const uploadBtn = screen.getByTestId('recipe-details-upload-button');
    expect(uploadBtn).toBeInTheDocument();
  });
});
