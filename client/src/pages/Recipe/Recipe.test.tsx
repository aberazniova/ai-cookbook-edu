import { screen, waitFor } from '@testing-library/react';
import { vi } from 'vitest';
import { renderWithRouter } from 'utils/testUtils';

import Recipe from './Recipe';
import { getRecipe } from 'utils/recipes';
import { recipeFixture } from 'utils/testFixtures';

const routerOptions = {
  route: '/recipe/1',
  path: '/recipe/:id',
};

vi.mock('utils/recipes', () => ({
  getRecipe: vi.fn(),
}));

describe('Recipe page', () => {
  beforeEach(() => {
    vi.mocked(getRecipe).mockResolvedValue(recipeFixture);
  });

  afterEach(() => {
    vi.resetAllMocks();
  });

  it('shows loading skeleton initially', () => {
    renderWithRouter(<Recipe />, routerOptions);
    expect(document.querySelectorAll('.animate-pulse').length > 0).toBe(true);
  });

  it('renders the page and recipe details after load', async () => {
    renderWithRouter(<Recipe />, routerOptions);

    await waitFor(() => {
      expect(screen.getByRole('heading', { name: /recipe details/i })).toBeInTheDocument();
      expect(screen.getByRole('heading', { name: /avocado toast/i })).toBeInTheDocument();
    });
  });

  it('shows not found state when recipe is missing', async () => {
    vi.mocked(getRecipe).mockResolvedValueOnce(undefined);
    renderWithRouter(<Recipe />, routerOptions);

    await waitFor(() => {
      expect(screen.getByRole('heading', { name: /recipe not found/i })).toBeInTheDocument();
    });
  });
});
