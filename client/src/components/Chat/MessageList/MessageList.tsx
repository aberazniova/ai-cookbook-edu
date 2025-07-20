import { useState, useEffect } from 'react';

import Message from 'components/Chat/MessageList/Message/Message';
import { type Message as MessageType } from 'types/messages';
import { getMessages } from 'utils/messages';
import LoadingSpinner from 'components/Common/LoadingSpinner/LoadingSpinner';

function MessageList() {
  const [messages, setMessages] = useState<MessageType[]>([]);
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
  }, []);

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
