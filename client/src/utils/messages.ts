import { apiBaseUrl } from 'utils/api';
import { authFetch } from 'utils/authFetch';
import { Message, Artifact } from 'types/messages';
import camelcaseKeys from 'camelcase-keys';
import { addMessage } from 'stores/messagesStore';
import { clearArtifacts } from 'stores/artifactsStore';
import { handleNewArtifact } from 'utils/artifacts';
import { getCurrentRecipe } from 'stores/recipesStore';

export const sendMessage = async (message: string): Promise<void> => {
  clearArtifacts();

  const response = await authFetch(`${apiBaseUrl}/messages`, {
    method: 'POST',
    body: JSON.stringify({
      message,
      viewed_recipe_id: getCurrentRecipe()?.id
    }),
    credentials: 'include',
  });
  const data = await response.json().catch(() => ({}));

  if (!response.ok) {
    throw new Error(`Error processing message! ${data.message || `status: ${response.status}`}`);
  }

  const newMessages = camelcaseKeys(data.messages, { deep: true }) as Message[];
  const newArtifacts = camelcaseKeys(data.artifacts, { deep: true }) as Artifact[];

  newMessages.forEach((newMessage) => {
    addMessage(newMessage);
  });
  newArtifacts.forEach((newArtifact) => {
    handleNewArtifact(newArtifact);
  });
};

export const getMessages = async (): Promise<Message[]> => {
  const response = await authFetch(`${apiBaseUrl}/messages`, {
    credentials: 'include',
  });
  const data = await response.json().catch(() => ({}));

  if (!response.ok) {
    throw new Error(`Error loading messages! ${data.message || `status: ${response.status}`}`);
  }

  return camelcaseKeys(data);
};
