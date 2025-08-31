import { screen } from '@testing-library/react';
import { renderWithRouter } from 'utils/testUtils';
import { vi } from 'vitest';
import Artifacts from './Artifacts';
import * as artifactsStore from 'stores/artifactsStore';
import { Artifact } from 'types/messages';
import { RecipeCard } from 'types/recipes';

describe('Artifacts', () => {
  const mockArtifacts: Artifact[] = [
    {
      kind: 'recipe_created',
      data: { title: 'Recipe 1' } as RecipeCard,
    },
    {
      kind: 'recipe_updated',
      data: { title: 'Recipe 2' } as RecipeCard,
    },
    {
      kind: 'unknown',
      data: { title: 'Unknown Recipe' } as RecipeCard,
    },
  ];

  beforeEach(() => {
    vi.spyOn(artifactsStore, 'useArtifactsStore').mockReturnValue({ artifacts: mockArtifacts });
  });

  afterEach(() => {
    vi.clearAllMocks();
  });

  it('renders ViewRecipe for recipe_created artifact kind', () => {
    renderWithRouter(<Artifacts />);
    expect(screen.getByText('Recipe 1')).toBeInTheDocument();
  });

  it('renders ViewRecipe for recipe_updated artifact kind', () => {
    renderWithRouter(<Artifacts />);
    expect(screen.getByText('Recipe 2')).toBeInTheDocument();
  });

  it('does not render anything for unknown artifact kind', () => {
    renderWithRouter(<Artifacts />);
    expect(screen.queryByText('Unknown Recipe')).not.toBeInTheDocument();
  });
});
