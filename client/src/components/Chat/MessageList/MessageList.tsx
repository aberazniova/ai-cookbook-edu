import { useState, useEffect } from 'react';

import Message from 'components/Chat/MessageList/Message/Message';
import { getMessages } from 'utils/messages';
import LoadingSpinner from 'components/Common/LoadingSpinner/LoadingSpinner';
import { useMessagesStore } from 'stores/messagesStore';
import { useAlertStore } from 'stores/alertStore';
import { useAuthStore } from 'stores/authStore';

function MessageList() {
  const messages = useMessagesStore((state) => state.messages);
  const setMessages = useMessagesStore((state) => state.setMessages);
  const addAlert = useAlertStore((state) => state.addAlert);
  const user = useAuthStore((state) => state.user);

  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    const fetchMessages = async () => {
      if (!user) {
        setMessages([]);
        setIsLoading(false);
        return;
      }

      try {
        setIsLoading(true);

        const messagesHistory = await getMessages();
        setMessages(messagesHistory);
      } catch (error) {
        addAlert({
          type: 'failure',
          message: error.message || 'Failed to load message history.',
        });
      } finally {
        setIsLoading(false);
      }
    };

    fetchMessages();
  }, [setMessages, addAlert, user]);

  return (
    <div className="flex-1 p-5 lg:p-6 overflow-y-auto custom-scrollbar">
      {isLoading ? (
        <LoadingSpinner />
      ) : (
        messages?.map((message, index) => (
          <Message key={index} message={message} />
        ))
      )}
    </div>
  );
}

export default MessageList;
