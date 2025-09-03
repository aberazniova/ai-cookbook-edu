import ReactMarkdown from 'react-markdown';
import { FaRobot as Bot } from 'react-icons/fa';
import { FiUser as UserIcon } from 'react-icons/fi';
import { motion } from 'framer-motion';

import { type Message as MessageType } from 'types/messages';
import classNames from 'classnames';

function Message({ message }: { message: MessageType }) {
  const { textContent, role, id } = message;

  const isUserMessage = role === 'user';
  const isModelMessage = role === 'model';

  return (
    <motion.div
      key={id}
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      exit={{ opacity: 0, y: -20 }}
      className={classNames({
        'flex gap-3': true,
        'justify-end': isUserMessage,
        'justify-start': isModelMessage
      })}
      data-testid="message"
    >
      {isModelMessage && (
        <div
          className="w-8 h-8 rounded-full flex items-center justify-center flex-shrink-0 bg-sage-green"
        >
          <Bot className="w-4 h-4 text-white" />
        </div>
      )}

      <div
        className={classNames({
          'max-w-[85%]': true,
          'order-1': isUserMessage,
        })}
      >
        <div
          className={classNames('px-4 py-2 rounded-2xl whitespace-normal prose compact-prose prose-ul:pl-4', {
            'text-white shadow-md bg-terracotta text-right': isUserMessage,
            'bg-gray-50 text-gray-900 text-left': isModelMessage,
          })}
        >
          <ReactMarkdown>{textContent}</ReactMarkdown>
        </div>
      </div>

      {isUserMessage && (
        <div className="w-8 h-8 rounded-full bg-gray-200 flex items-center justify-center flex-shrink-0">
          <UserIcon className="w-4 h-4 text-gray-600" />
        </div>
      )}
    </motion.div>
  );
}

export default Message;
