import { FiMic as Mic } from 'react-icons/fi';
import classNames from 'classnames';

import { useAlertStore } from 'stores/alertStore';
import useSpeechRecognition from 'hooks/useSpeechRecognition';
import { Button } from 'flowbite-react';

type Props = {
  disabled: boolean;
  onResult: (result: string) => void,
};

function VoiceInput({ disabled, onResult }: Props) {
  const addAlert = useAlertStore((state) => state.addAlert);

  const handleError = (error: string) => {
    addAlert({ type: 'failure', message: error });
  };

  const { isListening, isSupported, startListening, stopListening } = useSpeechRecognition({
    onResult,
    onError: handleError,
  });

  const toggleVoiceInput = () => {
    if (isListening) {
      startListening();
    } else {
      stopListening();
    }
  };

  if (!isSupported) {
    return;
  }

  return (
    <Button
      type="button"
      onClick={toggleVoiceInput}
      disabled={disabled}
      className={
        classNames({
          'rounded-xl shadow-md hover:shadow-lg transition-all duration-200 px-3 border outline-none focus:ring focus:ring-terracotta-400': true,
          'text-white animate-pulse bg-terracotta border-terracotta': isListening,
          'text-gray-600 hover:text-gray-800 bg-while': !isListening,
        })
      }
      aria-label={isListening ? 'Stop voice input' : 'Start voice input'}
    >
      {isListening ? <Mic className="w-4 h-4 animate-pulse" /> : <Mic className="w-4 h-4" />}
    </Button>
  );
}

export default VoiceInput;
