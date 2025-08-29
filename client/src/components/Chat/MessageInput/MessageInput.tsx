import { FaSpinner as Loader2 } from 'react-icons/fa';
import { useEffect, useState } from 'react';
import { FiSend as Send, FiMic as Mic } from 'react-icons/fi';
import { Textarea, Button } from 'flowbite-react';
import classNames from 'classnames';
import SpeechRecognition, { useSpeechRecognition } from 'react-speech-recognition';

import { sendMessage } from 'utils/messages';
import { useMessagesStore } from 'stores/messagesStore';
import { useAlertStore } from 'stores/alertStore';

function MessageInput() {
  const [message, setMessage] = useState('');
  const setResponseLoading = useMessagesStore((state) => state.setResponseLoading);
  const responseLoading = useMessagesStore((state) => state.responseLoading);

  const addMessage = useMessagesStore((state) => state.addMessage);
  const addAlert = useAlertStore((state) => state.addAlert);

  const {
    transcript,
    listening,
    resetTranscript,
    browserSupportsSpeechRecognition,
  } = useSpeechRecognition();

  const startListening = () => {
    resetTranscript();
    SpeechRecognition.startListening({ continuous: true, language: 'en-US' });
  };

  const stopListening = () => {
    SpeechRecognition.stopListening();
  };

  const handleSendMessage = async () => {
    if (message.trim() === '' || responseLoading) return;

    addMessage({
      id: String(Date.now()),
      textContent: message,
      role: 'user',
    });

    if (listening) {
      SpeechRecognition.stopListening();
    }

    setMessage('');
    setResponseLoading(true);

    try {
      const newMessages = await sendMessage(message);

      if (!newMessages) {
        return;
      }

      newMessages.forEach((newMessage) => {
        addMessage({
          id: String(newMessage.id),
          textContent: newMessage.textContent,
          role: newMessage.role,
        });
      });
    } catch (error) {
      addAlert({
        type: 'failure',
        message: error.message || 'An unexpected error occurred while processing your message.',
      });
    } finally {
      setResponseLoading(false);
    }
  };

  const handleKeyDown = (event: React.KeyboardEvent<HTMLTextAreaElement>) => {
    if (event.key === 'Enter' && !event.shiftKey) {
      event.preventDefault();
      handleSendMessage();
    }
  };

  const toggleVoiceInput = () => {
    if (listening) {
      stopListening();
    } else {
      startListening();
    }
  };

  useEffect(() => {
    if (listening) {
      setMessage(transcript);
    }
  }, [listening, transcript]);

  return (
    <div className="p-4 border-t border-gray-100 bg-gray-50">
      <div className="flex gap-3">
        <Textarea
          value={message}
          onChange={(e) => setMessage(e.target.value)}
          onKeyDown={handleKeyDown}
          placeholder="Type your message here..."
          className="flex-1 border-gray-200 bg-white shadow-sm focus:border-gray-200 px-4 py-2 rounded-xl placeholder-gray-500"
          aria-label="Chat input"
          disabled={responseLoading}
          rows={1}
        />
        {browserSupportsSpeechRecognition && (
          <Button
            type="button"
            onClick={toggleVoiceInput}
            disabled={responseLoading}
            className={
              classNames({
                'rounded-xl shadow-md hover:shadow-lg transition-all duration-200 px-3 border outline-none focus:ring focus:ring-terracotta-400': true,
                'text-white animate-pulse bg-terracotta border-terracotta': listening,
                'text-gray-600 hover:text-gray-800 bg-while': !listening,
              })
            }
            aria-label={listening ? 'Stop voice input' : 'Start voice input'}
            data-testid="voice-input-button"
          >
            {listening ? <Mic className="w-4 h-4 animate-pulse" /> : <Mic className="w-4 h-4" />}
          </Button>
        )}
        <Button
          type="button"
          onClick={handleSendMessage}
          disabled={!message.trim() || responseLoading}
          className="rounded-xl text-white shadow-md hover:shadow-lg px-3 bg-terracotta hover:bg-terracotta-700 focus:ring-0"
          aria-label="Send message"
          data-testid="send-button"
        >
          {responseLoading ? <Loader2 className="w-4 h-4 animate-spin" /> : <Send className="w-4 h-4" />}
        </Button>
      </div>
    </div>
  );
}

export default MessageInput;
