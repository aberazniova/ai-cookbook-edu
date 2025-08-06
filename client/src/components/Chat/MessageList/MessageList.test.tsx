import { render, screen } from '@testing-library/react';
import '@testing-library/jest-dom';
import MessageList from './MessageList';
import { waitFor } from '@testing-library/dom';

const messagesResponse = {
  messages: [
    { textContent: 'Hello', role: 'user' },
    { textContent: 'Hi', role: 'assistant' },
    { textContent: 'How are you?', role: 'user' },
    { textContent: 'I am fine.', role: 'assistant' },
    { textContent: 'Great!', role: 'user' },
  ]
};

beforeAll(() => {
  global.fetch = vi.fn((url) => {
    if (url === `/messages`) {
      return Promise.resolve({
        ok: true,
        json: () => Promise.resolve(messagesResponse),
      });
    }
    return Promise.reject(new Error('Unknown endpoint'));
  });
});

afterAll(() => {
  vi.resetAllMocks();
});

describe('MessageList', () => {
  it('renders the message content', async () => {
    render(<MessageList />);

    await waitFor(() => {
      const messages = screen.queryAllByTestId('message');
      expect(messages).toHaveLength(5);
    });
  });
});
