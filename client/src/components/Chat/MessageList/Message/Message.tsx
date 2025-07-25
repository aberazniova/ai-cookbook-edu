import ReactMarkdown from 'react-markdown';
import { type Message as MessageType } from 'types/messages';

function Message({ message }: { message: MessageType }) {
  const { textContent, role } = message;

  const isUserMessage = role === 'user';

  const color = isUserMessage ? 'bg-emerald-100 dark:bg-emerald-900' : 'bg-stone-200 dark:bg-neutral-700';
  const textColor = isUserMessage ? 'text-gray-800 dark:text-gray-100' : 'text-gray-700 dark:text-gray-200';
  const position = isUserMessage ? 'justify-end' : 'justify-start';

  return (
    <div className={`mb-4 flex ${position}`}>
      <div className={`${color} ${textColor} p-3 lg:p-4 rounded-xl max-w-[85%] text-left shadow-sm`}>
        <div className="text-sm lg:text-base">
          <ReactMarkdown>{textContent}</ReactMarkdown>
        </div>
      </div>
    </div>
  );
}

export default Message;
