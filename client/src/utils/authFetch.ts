import { useAuthStore } from 'stores/authStore';

const getToken = () => useAuthStore.getState().token;

export const authFetch = async (input: RequestInfo | URL, init: RequestInit = {}) => {
  const token = getToken();
  const headers = new Headers(init.headers || {});
  headers.set('Content-Type', 'application/json');

  if (token) headers.set('Authorization', token);

  const resp = await fetch(input, { ...init, headers });
  return resp;
};
