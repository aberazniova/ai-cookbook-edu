import { useState, useEffect, useRef } from 'react';
import { motion, AnimatePresence } from 'framer-motion';

import Message from 'components/Chat/MessageList/Message/Message';
import { getMessages } from 'utils/messages';
import { useMessagesStore } from 'stores/messagesStore';
import { useAlertStore } from 'stores/alertStore';

import { FaRobot as Bot, FaSpinner as Loader2 } from 'react-icons/fa';
import Artifacts from './Artifacts/Artifacts';

function MessageList() {
  const { messages, setMessages, responseLoading } = useMessagesStore();
  const addAlert = useAlertStore((state) => state.addAlert);
  const messagesEndRef = useRef(null);

  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    scrollToBottom();
  }, [messages]);

  const scrollToBottom = () => {
    if (typeof messagesEndRef.current?.scrollIntoView !== "function")
      return;

    messagesEndRef.current.scrollIntoView({ behavior: "smooth" });
  };

  useEffect(() => {
    const fetchMessages = async () => {
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
  }, [setMessages, addAlert]);

  return (
    <div className="flex-1 overflow-y-auto p-4">
      {isLoading && (
        <div className="flex items-center justify-center">
          <Loader2 className="w-6 h-6 animate-spin" />
        </div>
      )}
      <AnimatePresence>
        <div className="flex-1 space-y-4 mb-4">
          {messages.map((message) => (
            <Message key={message.id} message={message} />
          ))}
        </div>
      </AnimatePresence>
      {
        responseLoading && (
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            className="flex gap-3 mb-4"
          >
            <div
              className="w-8 h-8 rounded-full flex items-center justify-center bg-sage-green"
            >
              <Bot className="w-4 h-4 text-white" />
            </div>
            <div className="bg-gray-50 p-4 rounded-2xl">
              <div className="flex items-center gap-2">
                <Loader2 className="w-4 h-4 animate-spin" />
                <span className="text-sm text-gray-600">Cooking up a response...</span>
              </div>
            </div>
          </motion.div>
        )
      }

      <Artifacts />

      <div className="h-0" ref={messagesEndRef} />
    </div >
  );
}

export default MessageList;
