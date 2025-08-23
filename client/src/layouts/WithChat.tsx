import { Outlet } from 'react-router-dom';
import { useState, useEffect } from 'react';
import Chat from 'components/Chat/Chat';
import { FiMessageCircle as MessageCircle } from 'react-icons/fi';

function WithChat() {
  const [isChatOpen, setIsChatOpen] = useState(false);

  useEffect(() => {
    const checkMobile = () => {
      const mobile = window.innerWidth < 768;
      setIsChatOpen(!mobile);
    };

    checkMobile();
    window.addEventListener('resize', checkMobile);

    return () => window.removeEventListener('resize', checkMobile);
  }, []);

  return (
    <>
      <div className="flex-1 overflow-y-auto">
        <Outlet />
      </div>
      {isChatOpen ? (
        <aside className="bg-slate-200 w-full max-w-lg border-l border-gray-200 flex flex-col rounded-2">
          <Chat onClose={() => setIsChatOpen(false)} />
        </aside>
      ) : (
        <button
          onClick={() => setIsChatOpen(true)}
          className={`
            fixed bottom-6 right-6 rounded-full w-16 h-16 shadow-lg text-white z-20 flex items-center
            justify-center bg-terracotta hover:bg-terracotta-700
          `}
          aria-label="Open Chat"
        >
          <MessageCircle className="w-8 h-8" />
        </button>
      )}
    </>
  );
}

export default WithChat;
