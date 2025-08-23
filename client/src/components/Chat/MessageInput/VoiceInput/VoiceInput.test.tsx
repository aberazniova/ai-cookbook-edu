import { render, screen } from '@testing-library/react';
import { vi } from 'vitest';
import '@testing-library/jest-dom';
import VoiceInput from './VoiceInput';

vi.mock(import("hooks/useSpeechRecognition"), async (importOriginal) => {
  const actual = await importOriginal()
  return {
    ...actual,
    isListening: true,
    isSupported: true,
    startListening: vi.fn(),
    stopListening: vi.fn(),
  }
});

describe('VoiceInput', () => {
  it('renders the voice intup button when it is supported', () => {
    render(<VoiceInput disabled={false} onResult={vi.fn()} />);
    expect(screen.getByRole('button')).toBeInTheDocument();
  });
});
