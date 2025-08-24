import { render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { vi } from 'vitest';
import RecipeStats from './RecipeStats';

const baseProps = {
  cookingTime: 45,
  servings: 3,
  difficulty: 'hard',
  onServingsChanged: vi.fn(),
};

describe('RecipeStats', () => {
  it('renders cooking time', () => {
    render(<RecipeStats {...baseProps} />);
    expect(screen.getByText(/45 min/i)).toBeInTheDocument();
  });

  it('renders servings value', () => {
    render(<RecipeStats {...baseProps} />);
    expect(screen.getByText('3')).toBeInTheDocument();
  });

  it('renders difficulty', () => {
    render(<RecipeStats {...baseProps} />);
    expect(screen.getByText(/hard/i)).toBeInTheDocument();
  });

  it('disables decrement at 1 serving', () => {
    render(<RecipeStats {...baseProps} servings={1} />);
    const decrement = screen.getByTestId('recipe-stats-decrement-button');
    expect(decrement).toBeDisabled();
  });

  it('calls onServingsChanged with incremented value', async () => {
    const onChange = vi.fn();
    render(<RecipeStats {...baseProps} onServingsChanged={onChange} />);

    const increment = screen.getByTestId('recipe-stats-increment-button');
    await userEvent.click(increment);

    expect(onChange).toHaveBeenCalledWith(4);
  });
});
