import { apiBaseUrl } from 'utils/api';
import { getAuth, setAuth } from 'stores/authStore';

export const signIn = async (email: string, password: string) => {
  const response = await fetch(`${apiBaseUrl}/auth/sign_in`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    credentials: 'include',
    body: JSON.stringify({ user: { email, password } }),
  });

  const data = await response.json().catch(() => ({}));

  if (!response.ok) {
    const errors = data.errors?.join?.(', ') || 'Failed to sign in';
    throw new Error(errors);
  }

  const token = response.headers.get('Authorization');
  if (!token || !data) throw new Error('Failed to sign in');

  setAuth(data, token);

  return { user: data, token };
};

export const signUp = async (email: string, password: string, passwordConfirmation: string) => {
  const response = await fetch(`${apiBaseUrl}/auth/sign_up`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    credentials: 'include',
    body: JSON.stringify({ user: { email, password, password_confirmation: passwordConfirmation } }),
  });

  const data = await response.json().catch(() => ({}));

  if (!response.ok) {
    const errors = data.errors?.join?.(', ') || 'Unable to sign up';
    throw new Error(errors);
  }

  const token = response.headers.get('Authorization');
  if (!token || !data) throw new Error('Failed to sign up');

  setAuth(data, token);

  return { user: data, token };
};

export const logout = async () => {
  const response = await fetch(
    `${apiBaseUrl}/auth/sign_out`,
    { method: 'DELETE', credentials: 'include' }
  );

  if (!response.ok) {
    const data = await response.json().catch(() => ({}));
    throw new Error(data.errors?.join?.(', ') || 'Failed to sign out');
  }

  getAuth().clearAuth();
};

export const refreshToken = async (): Promise<string | null> => {
  const refreshResponse = await fetch(
    `${apiBaseUrl}/auth/refresh`,
    { method: 'POST', credentials: 'include' }
  );

  if (refreshResponse.ok) {
    const newToken = refreshResponse.headers.get('Authorization');
    const data = await refreshResponse.json().catch(() => ({}));

    if (newToken && data) {
      setAuth(data, newToken);

      return newToken;
    }
  }

  return null;
};
