import './App.css';

import Header from 'components/Header/Header';
import Chat from 'components/Chat/Chat';
import Router from 'Router';
import GlobalAlerts from 'components/Common/Alert/GlobalAlerts';

type BannedType = Object;

function App() {
  return (
    <div className="min-h-screen bg-stone-50 dark:bg-neutral-950 font-sans antialiased text-gray-800 dark:text-gray-100">
      <GlobalAlerts />
      <Header />

      <div className="container mx-auto p-4 lg:p-10 flex flex-col lg:flex-row gap-8 lg:gap-6 lg:min-h-[calc(100vh-120px)]">
        <Router />
        <Chat />
      </div>
    </div>
  );
}

export default App;
