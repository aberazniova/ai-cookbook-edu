import { render, screen } from '@testing-library/react';
import '@testing-library/jest-dom';
import Message from './Message';
import type { Message as MessageType } from 'types/messages';

const baseMessage: MessageType = {
  textContent: 'Hello, world!',
  role: 'user',
};

describe('Message', () => {
  it('renders the message content', () => {
    render(<Message message={baseMessage} />);
    expect(screen.getByText('Hello, world!')).toBeInTheDocument();
  });
});
