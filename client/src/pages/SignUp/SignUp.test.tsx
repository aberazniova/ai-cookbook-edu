import { vi } from 'vitest';
import type { Mock } from 'vitest';
import { screen, waitFor } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { renderWithRouter } from 'utils/testUtils';
import SignUp from './SignUp';

const addAlertMock = vi.fn();

vi.mock('stores/alertStore', () => ({
  useAlertStore: (selector) => selector({ addAlert: addAlertMock })
}));

describe('SignUp', () => {
  beforeEach(() => {
    vi.clearAllMocks();
    global.fetch = vi.fn(async () =>
      new Response(
        JSON.stringify({ user: { id: 2, email: 'new@example.com' } }),
        { status: 200, headers: { Authorization: 'Bearer token' } }
      )
    );
  });

  it('renders Email input', () => {
    renderWithRouter(<SignUp />);
    expect(screen.getByLabelText('Email')).toBeInTheDocument();
  });

  it('renders Password input', () => {
    renderWithRouter(<SignUp />);
    expect(screen.getByLabelText('Password')).toBeInTheDocument();
  });

  it('renders Confirm Password input', () => {
    renderWithRouter(<SignUp />);
    expect(screen.getByLabelText('Confirm Password')).toBeInTheDocument();
  });

  it('renders Create Account button', () => {
    renderWithRouter(<SignUp />);
    expect(screen.getByRole('button', { name: /create account/i })).toBeInTheDocument();
  });

  describe('when the form is submitted', () => {
    const fillAndSubmitForm = async () => {
      await userEvent.type(screen.getByLabelText('Email'), 'new@example.com');
      await userEvent.type(screen.getByLabelText('Password'), 'Password1!');
      await userEvent.type(screen.getByLabelText('Confirm Password'), 'Password1!');
      await userEvent.click(screen.getByRole('button', { name: /create account/i }));
    };

    it('posts to sign_up endpoint with the provided data', async () => {
      renderWithRouter(<SignUp />);

      await fillAndSubmitForm();
      await waitFor(() => expect(global.fetch).toHaveBeenCalled());

      const [url, init] = (global.fetch as Mock).mock.calls[0];
      const body = JSON.parse(init?.body as string);

      expect(url).toMatch(/auth\/sign_up$/);
      expect(init?.method).toBe('POST');
      expect(body).toEqual({ user: { email: 'new@example.com', password: 'Password1!', password_confirmation: 'Password1!' } });
    });

    describe('when sign up is not successful', () => {
      it('shows an alert', async () => {
        (global.fetch as Mock).mockResolvedValueOnce(
          new Response(
            JSON.stringify({ errors: ['Invalid email or password'] }),
            { status: 401, headers: { 'Content-Type': 'application/json' } }
          )
        );
        renderWithRouter(<SignUp />);

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
