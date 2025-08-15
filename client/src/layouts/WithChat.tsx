import { Outlet } from 'react-router-dom';
import Chat from 'components/Chat/Chat';

function WithChat() {
  return (
    <div className="flex flex-row gap-6 lg:gap-8">
      <div className="basis-2/3">
        <Outlet />
      </div>
      <div className="basis-1/3">
        <Chat />
      </div>
    </div>
  );
}

export default WithChat;
