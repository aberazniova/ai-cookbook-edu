import { Outlet } from 'react-router-dom';
import { useState, useEffect } from 'react';
import Chat from 'components/Chat/Chat';
import { FiMessageCircle as MessageCircle } from 'react-icons/fi';
import classNames from 'classnames';

function WithChat() {
  const [isChatOpen, setIsChatOpen] = useState(false);
  const [smallScreen, setSmallScreen] = useState(false);

  useEffect(() => {
    const checkSmallScreen = () => {
      const smallScreen = window.innerWidth < 875;
      setIsChatOpen(!smallScreen);
      setSmallScreen(smallScreen);
    };

    checkSmallScreen();
    window.addEventListener('resize', checkSmallScreen);

    return () => window.removeEventListener('resize', checkSmallScreen);
  }, []);

  const chatOpenOnSmallScreen = () => smallScreen && isChatOpen;

  return (
    <>
      <div className={classNames({
        "flex-1 overflow-y-auto": true,
        "hidden": chatOpenOnSmallScreen()
      })}>
        <Outlet />
      </div>
      {isChatOpen ? (
        <aside className={classNames({
          "bg-slate-200 w-full border-l border-gray-200 flex flex-col rounded-2": true,
          "max-w-lg": !chatOpenOnSmallScreen()
        })}>
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
