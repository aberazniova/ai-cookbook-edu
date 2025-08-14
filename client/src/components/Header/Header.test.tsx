import { describe, it, expect, vi, beforeEach } from 'vitest';
import { screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { renderWithRouter } from 'utils/testUtils';
import { useAuthStore } from 'stores/authStore';
import Header from './Header';

const logoutMock = vi.fn();
vi.mock('utils/auth', () => ({ logout: () => logoutMock() }));

describe('Header', () => {
  beforeEach(() => vi.clearAllMocks());

  describe('when user is signed in', () => {
    const openUserMenu = async () => {
      await userEvent.click(screen.getByTestId('user-menu'));
    };

    beforeEach(() => {
      useAuthStore.getState().setAuth({ id: 1, email: 'user@example.com' }, 'test-token');
    });

    afterEach(() => {
      useAuthStore.getState().clearAuth();
    });

    it('renders user menu trigger', async () => {
      renderWithRouter(<Header />);
      expect(screen.getByTestId('user-menu')).toBeInTheDocument();
    });

    it('shows user email in dropdown', async () => {
      renderWithRouter(<Header />);
      await openUserMenu();

      expect(screen.getByText('user@example.com')).toBeInTheDocument();
    });

    it('shows logout button in dropdown', async () => {
      renderWithRouter(<Header />);
      await openUserMenu();

      expect(screen.getByTestId('logout-button')).toBeInTheDocument();
    });

    it('calls logout when logout is clicked', async () => {
      renderWithRouter(<Header />);

      await openUserMenu();
      await userEvent.click(screen.getByTestId('logout-button'));

      expect(logoutMock).toHaveBeenCalled();
    });
  });

  describe('when user is signed out', () => {
    beforeEach(() => {
      useAuthStore.getState().clearAuth();
    });

    it('renders Sign In button', () => {
      renderWithRouter(<Header />);
      expect(screen.getByRole('button', { name: /sign in/i })).toBeInTheDocument();
    });

    it('renders Sign Up button', () => {
      renderWithRouter(<Header />);
      expect(screen.getByRole('button', { name: /sign up/i })).toBeInTheDocument();
    });
  });
});
