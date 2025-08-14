import { apiBaseUrl } from 'utils/api';
import { authFetch } from 'utils/authFetch';
import { useAuthStore } from 'stores/authStore';

export const signIn = async (email: string, password: string) => {
  const response = await fetch(`${apiBaseUrl}/auth/sign_in`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ user: { email, password } }),
  });

  const data = await response.json();

  if (!response.ok) {
    const errors = data.errors?.join?.(', ') || 'Failed to sign in';
    throw new Error(errors);
  }

  const token = response.headers.get('Authorization');
  if (!token || !data?.user) throw new Error('Failed to sign in');

  useAuthStore.getState().setAuth(data.user, token);

  return { user: data.user, token };
};

export const signUp = async (email: string, password: string, passwordConfirmation: string) => {
  const resp = await fetch(`${apiBaseUrl}/auth/sign_up`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ user: { email, password, password_confirmation: passwordConfirmation } }),
  });

  const data = await resp.json();

  if (!resp.ok) {
    const errors = data.errors?.join?.(', ') || 'Unable to sign up';
    throw new Error(errors);
  }

  const token = resp.headers.get('Authorization');
  if (!token || !data?.user) throw new Error('Failed to sign up');

  useAuthStore.getState().setAuth(data.user, token);

  return { user: data.user, token };
};

export const logout = async () => {
  useAuthStore.getState().clearAuth();

  const resp = await authFetch(`${apiBaseUrl}/auth/sign_out`, { method: 'DELETE' });
  if (!resp.ok) {
    const data = await resp.json();
    throw new Error(data.errors?.join?.(', ') || 'Failed to sign out');
  }
};
