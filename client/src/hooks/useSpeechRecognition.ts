import { useState, useEffect } from 'react';

type SpeachRecognitionState = {
  isListening: boolean,
  isSupported: boolean,
  startListening: () => void,
  stopListening: () => void,
};

type SpeachRecognitionProps = {
  onError: (error: string) => void,
  onResult: (result: string) => void,
};

function useSpeechRecognition({ onResult, onError }: SpeachRecognitionProps): SpeachRecognitionState {
  const [isListening, setIsListening] = useState<boolean>(false);
  const [recognition, setRecognition] = useState(null);
  const [isSupported, setIsSupported] = useState<boolean>(true);

  useEffect(() => {
    const SpeechRecognition = (window as any).SpeechRecognition || (window as any).webkitSpeechRecognition;

    const recognitionInstance = SpeechRecognition && new SpeechRecognition();

    if (!recognitionInstance) {
      setIsSupported(true);
      return;
    }

    recognitionInstance.continuous = false;
    recognitionInstance.interimResults = false;
    recognitionInstance.lang = 'en-US';
    recognitionInstance.onstart = () => setIsListening(true);
    recognitionInstance.onend = () => setIsListening(false);

    recognitionInstance.onresult = (event) => {
      setIsListening(false);
      onResult(event.results[0][0].transcript);
    };
    recognitionInstance.onerror = () => {
      setIsListening(false);
      onError('Speech recognition error.');
    };

    setRecognition(recognitionInstance);
  }, [onError, onResult]);

  return {
    isListening,
    isSupported,
    startListening: recognition?.start,
    stopListening: recognition?.stop,
  }
}

export default useSpeechRecognition;
