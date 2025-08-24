import { render, screen } from '@testing-library/react';
import { vi } from 'vitest';
import MessageInput from './MessageInput';

vi.mock('react-speech-recognition', () => ({
  default: {
    startListening: vi.fn(),
    stopListening: vi.fn(),
  },
  useSpeechRecognition: () => ({
    transcript: '',
    listening: false,
    resetTranscript: vi.fn(),
    browserSupportsSpeechRecognition: true,
  }),
}));

describe('MessageInput', () => {
  it('renders the text area', () => {
    render(<MessageInput />);
    expect(screen.getByRole('textbox')).toBeInTheDocument();
  });

  it('renders the voice input button when it is supported', () => {
    render(<MessageInput />);
    expect(screen.getByTestId('voice-input-button')).toBeInTheDocument();
  });

  it('renders the send message button', () => {
    render(<MessageInput />);
    expect(screen.getByTestId('send-button')).toBeInTheDocument();
  });
});
