import { Textarea, Button } from 'flowbite-react';
import { HiPaperAirplane } from 'react-icons/hi';

function Chat() {
  return (
    <div className="p-5 lg:p-6 border-t border-stone-200 dark:border-neutral-700">
      <Textarea
        id="chat-input"
        placeholder="Ask me for a recipe..."
        rows={3}
        className="w-full rounded-xl border border-stone-300 dark:border-neutral-600 bg-stone-100 dark:bg-neutral-700 text-gray-900 dark:text-gray-100
focus:ring-emerald-600 focus:border-emerald-600 placeholder-gray-400 dark:placeholder-gray-400 resize-none"
        sizing="sm"
      />
      <Button
        className="mt-4 w-full bg-emerald-600 hover:bg-emerald-700 dark:bg-emerald-500 dark:hover:bg-emerald-600 text-white font-semibold
focus:outline-none focus:ring-2 focus:ring-emerald-600 focus:ring-opacity-50
rounded-xl transition-all duration-200 shadow-md hover:shadow-lg py-3"
      >
        Send <HiPaperAirplane className="ml-2 h-5 w-5 transform rotate-90" />
      </Button>
    </div>
  );
}

export default Chat;
