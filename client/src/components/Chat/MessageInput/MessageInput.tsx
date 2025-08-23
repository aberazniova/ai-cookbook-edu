import { FaSpinner as Loader2 } from 'react-icons/fa';
import { useState } from 'react';
import { FiSend as Send } from 'react-icons/fi';
import { Textarea, Button } from 'flowbite-react';

import { sendMessage } from 'utils/messages';
import { useMessagesStore } from 'stores/messagesStore';
import { useAlertStore } from 'stores/alertStore';
import VoiceInput from 'components/Chat/MessageInput/VoiceInput/VoiceInput';

function MessageInput() {
  const [message, setMessage] = useState('');
  const [isLoading, setIsLoading] = useState(false);

  const addMessage = useMessagesStore((state) => state.addMessage);
  const addAlert = useAlertStore((state) => state.addAlert);

  const handleSendMessage = async () => {
    if (message.trim() === '' || isLoading) return;

    addMessage({
      id: String(Date.now()),
      textContent: message,
      role: 'user',
    });

    setMessage('');
    setIsLoading(true);

    try {
      const response = await sendMessage(message);

      if (!response) {
        return;
      }

      addMessage({
        id: String(Date.now() + 1),
        textContent: response,
        role: 'model',
      });
    } catch (error) {
      addAlert({
        type: 'failure',
        message: error.message || 'An unexpected error occurred while processing your message.',
      });
    } finally {
      setIsLoading(false);
    }
  };

  const handleKeyDown = (event: React.KeyboardEvent<HTMLTextAreaElement>) => {
    if (event.key === 'Enter' && !event.shiftKey) {
      event.preventDefault();
      handleSendMessage();
    }
  };

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
          disabled={isLoading}
          rows={1}
        />
        <VoiceInput disabled={isLoading} onResult={setMessage} />
        <Button
          type="button"
          onClick={handleSendMessage}
          disabled={!message.trim() || isLoading}
          className="rounded-xl text-white shadow-md hover:shadow-lg px-3 bg-terracotta hover:bg-terracotta-700 focus:ring-0"
          aria-label="Send message"
          data-testid="send-button"
        >
          {isLoading ? <Loader2 className="w-4 h-4 animate-spin" /> : <Send className="w-4 h-4" />}
        </Button>
      </div>
    </div>
  );
}

export default MessageInput;
