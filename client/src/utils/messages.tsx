import { apiBaseUrl } from 'utils/api';

export const sendMessage = async (message: string): Promise<string> => {
  const response = await fetch(`${apiBaseUrl}/messages`, {
    method: 'POST',
    body: JSON.stringify({ message }),
    headers: {
      'Content-Type': 'application/json',
    },
  });
  const data = await response.json();

  if (!response.ok) {
    throw new Error(`Error processing message! ${data.message || `status: ${response.status}`}`);
  }

  return data.message;
};
