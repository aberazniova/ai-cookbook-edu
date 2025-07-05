import { HiChatAlt2 } from 'react-icons/hi';
import MessageInput from './MessageInput/MessageInput';
import MessageList from './MessageList/MessageList';

function Chat() {
  return (
    <div className="w-full lg:w-1/3 min-w-[425px] flex-shrink-0 bg-white dark:bg-neutral-800 rounded-2xl shadow-2xl border border-stone-100 dark:border-neutral-700 flex flex-col
 lg:max-h-[calc(100vh-120px-theme(spacing.8)-theme(spacing.8)-theme(spacing.4))] lg:self-start">
      <div className="p-5 lg:p-6 border-b border-stone-200 dark:border-neutral-700 flex items-center gap-3">
        <HiChatAlt2 className="text-emerald-600 dark:text-emerald-400 text-3xl lg:text-4xl" />
        <h2 className="text-xl lg:text-2xl font-semibold text-gray-800 dark:text-gray-100">Culinary Assistant</h2>
      </div>
      <MessageList />
      <MessageInput />
    </div>
  );
}

export default Chat;
