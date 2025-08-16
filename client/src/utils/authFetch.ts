import { getAuth } from 'stores/authStore';
import { refreshToken } from 'utils/auth';

export const authFetch = async (
  input: RequestInfo | URL,
  init: RequestInit = {},
) => {
  const token = getAuth().token;
  const headers = new Headers(init.headers || {});
  headers.set('Content-Type', 'application/json');

  if (token) headers.set('Authorization', token);

  const doFetch = () => fetch(input, {
    ...init,
    headers,
  });

  let response = await doFetch();

  if (response.status === 401) {
    const newToken = await refreshToken();

    if (newToken) {
      headers.set('Authorization', newToken);
      response = await doFetch();
    }
  }

  return response;
};
