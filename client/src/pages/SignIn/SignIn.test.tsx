import { describe, it, expect, vi, beforeEach } from 'vitest';
import type { Mock } from 'vitest';
import { screen, waitFor } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import SignIn from './SignIn';
import { renderWithRouter } from 'utils/testUtils';

const addAlertMock = vi.fn();

vi.mock('stores/alertStore', () => ({
  useAlertStore: (selector) => selector({ addAlert: addAlertMock })
}));

describe('SignIn', () => {
  beforeEach(() => {
    vi.clearAllMocks();
    global.fetch = vi.fn(async () =>
      new Response(
        JSON.stringify({ user: { id: 1, email: 'test@example.com' } }),
        { status: 200, headers: { Authorization: 'Bearer token', 'Content-Type': 'application/json' } }
      )
    );
  });

  it('renders Email input', () => {
    renderWithRouter(<SignIn />);
    expect(screen.getByLabelText('Email')).toBeInTheDocument();
  });

  it('renders Password input', () => {
    renderWithRouter(<SignIn />);
    expect(screen.getByLabelText('Password')).toBeInTheDocument();
  });

  it('renders Sign In button', () => {
    renderWithRouter(<SignIn />);
    expect(screen.getByRole('button', { name: /sign in/i })).toBeInTheDocument();
  });

  describe('when form is submitted', () => {
    const fillAndSubmitForm = async () => {
      await userEvent.type(screen.getByLabelText('Email'), 'test@example.com');
      await userEvent.type(screen.getByLabelText('Password'), 'Password1!');
      await userEvent.click(screen.getByRole('button', { name: /sign in/i }));
    };

    it('posts to sign_in endpoint with the provided data', async () => {
      renderWithRouter(<SignIn />);

      await fillAndSubmitForm();
      await waitFor(() => expect(global.fetch).toHaveBeenCalled());

      const [url, init] = (global.fetch as Mock).mock.calls[0];
      const body = JSON.parse(init?.body as string);

      expect(url).toMatch(/auth\/sign_in$/);
      expect(init?.method).toBe('POST');
      expect(body).toEqual({ user: { email: 'test@example.com', password: 'Password1!' } });
    });

    describe('when sign in is not successful', () => {
      it('shows an alert', async () => {
        (global.fetch as Mock).mockResolvedValueOnce(
          new Response(
            JSON.stringify({ errors: ['Invalid email or password'] }),
            { status: 401, headers: { 'Content-Type': 'application/json' } }
          )
        );
        renderWithRouter(<SignIn />);

        await fillAndSubmitForm();
        await waitFor(() => {
          expect(addAlertMock).toHaveBeenCalledWith({
            message: 'Invalid email or password',
            type: 'failure',
          });
        });
      });
    });
  });
});
