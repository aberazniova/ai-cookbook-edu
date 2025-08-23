import { render, screen } from '@testing-library/react';
import '@testing-library/jest-dom';
import MessageInput from './MessageInput';

describe('MessageInput', () => {
  it('renders the text area', () => {
    render(<MessageInput />);
    expect(screen.getByRole('textbox')).toBeInTheDocument();
  });

  it('renders the send message button', () => {
    render(<MessageInput />);
    expect(screen.getByTestId('send-button')).toBeInTheDocument();
  });
});
