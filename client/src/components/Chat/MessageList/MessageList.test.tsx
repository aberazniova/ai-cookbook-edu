import { render, screen } from '@testing-library/react';
import '@testing-library/jest-dom';
import MessageList from './MessageList';
import { waitFor } from '@testing-library/dom';
import { vi } from 'vitest';
import { useAuthStore } from 'stores/authStore';

const messagesResponse = [
  { textContent: 'Hello', role: 'user' },
  { textContent: 'Hi', role: 'model' },
  { textContent: 'How are you?', role: 'user' },
  { textContent: 'I am fine.', role: 'model' },
  { textContent: 'Great!', role: 'user' },
];

beforeAll(() => {
  global.fetch = vi.fn((url) => {
    if (url === `/messages`) {
      return Promise.resolve({
        ok: true,
        json: () => Promise.resolve(messagesResponse),
      } as Response);
    }
    return Promise.reject(new Error('Unknown endpoint'));
  });
});

afterAll(() => {
  vi.resetAllMocks();
});

describe('MessageList', () => {
  beforeEach(() => {
    useAuthStore.getState().setAuth({ id: 1, email: 'user@example.com' }, 'test-token');
  });

  afterEach(() => {
    useAuthStore.getState().clearAuth();
  });

  it('renders the message content', async () => {
    render(<MessageList />);

    await waitFor(() => {
      const messages = screen.queryAllByTestId('message');
      expect(messages).toHaveLength(5);
    });
  });
});

