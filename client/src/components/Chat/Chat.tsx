import { TbChefHat as ChefHat } from 'react-icons/tb';
import MessageInput from 'components/Chat/MessageInput/MessageInput';
import MessageList from 'components/Chat/MessageList/MessageList';
import { FiX as X } from 'react-icons/fi';

function Chat({ onClose }: { onClose: () => void }) {
  return (
    <div className="flex flex-col h-full bg-white overflow-hidden">
      <div
        className="px-6 py-4 border-b border-gray-100 flex justify-between items-center bg-sage-green-200"
      >
        <div className="flex items-center gap-3">
          <div
            className="w-10 h-10 rounded-full flex items-center justify-center bg-sage-green"
          >
            <ChefHat className="w-5 h-5 text-white" />
          </div>
          <div className="text-start">
            <h3 className="font-bold text-gray-900">Recipe Assistant</h3>
            <p className="text-sm text-gray-600">Your AI cooking companion</p>
          </div>
        </div>
        <button onClick={onClose} className="p-2 rounded-md hover:bg-gray-100" aria-label="Close chat">
          <X className="w-5 h-5 text-gray-600" />
        </button>
      </div>
      <MessageList />
      <MessageInput />
    </div>
  );
}

export default Chat;
