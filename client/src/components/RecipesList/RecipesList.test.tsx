import { screen, waitFor } from '@testing-library/react';
import { vi } from 'vitest';
import RecipesList from './RecipesList';
import { recipeCardFixture } from 'utils/testFixtures';
import { useAuthStore } from 'stores/authStore';
import { getRecipesList } from 'utils/recipes';
import { renderWithRouter } from 'utils/testUtils';

vi.mock('utils/recipes', () => ({
  getRecipesList: vi.fn(),
}));

describe('RecipesList', () => {
  beforeEach(() => {
    useAuthStore.getState().setAuth({ id: 1, email: 'x@y.com' }, 'token');
    vi.mocked(getRecipesList).mockResolvedValue([recipeCardFixture]);
  });

  afterEach(() => {
    vi.resetAllMocks();
    useAuthStore.getState().clearAuth();
  });

  it('renders loading skeleton initially', () => {
    renderWithRouter(<RecipesList />);
    expect(document.querySelectorAll('.animate-pulse').length > 0).toBe(true);
  });

  it('renders recipe cards', async () => {
    renderWithRouter(<RecipesList />);
    await waitFor(() => {
      expect(screen.getByText(/classic pasta/i)).toBeInTheDocument();
    });
  });

  describe('when no recipes are present', () => {
    beforeEach(() => {
      vi.mocked(getRecipesList).mockResolvedValueOnce([]);
    });

    it('shows empty state when no recipes', async () => {
      renderWithRouter(<RecipesList />);
      await waitFor(() => {
        expect(screen.getByText(/you haven't created any recipes yet/i)).toBeInTheDocument();
      });
    });
  });
});
