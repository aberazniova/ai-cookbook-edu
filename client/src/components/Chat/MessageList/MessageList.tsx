import { useState, useEffect } from 'react';

import Message from 'components/Chat/MessageList/Message/Message';
import { getMessages } from 'utils/messages';
import LoadingSpinner from 'components/Common/LoadingSpinner/LoadingSpinner';
import { useMessagesStore } from 'stores/messagesStore';

function MessageList() {
  const messages = useMessagesStore((state) => state.messages);
  const setMessages = useMessagesStore((state) => state.setMessages);

  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    const fetchMessages = async () => {
      try {
        setIsLoading(true);

        const messagesHistory = await getMessages();
        setMessages(messagesHistory);
      } catch (error) {
        console.error(error);
      } finally {
        setIsLoading(false);
      }
    };

    fetchMessages();
  }, [setMessages]);

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
