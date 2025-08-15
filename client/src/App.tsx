import './App.css';

import Header from 'components/Header/Header';
import Router from 'Router';
import GlobalAlerts from 'components/Common/Alert/GlobalAlerts';

function App() {
  return (
    <div className="h-[100vh] bg-stone-50 dark:bg-neutral-950 font-sans antialiased text-gray-800 dark:text-gray-100">
      <GlobalAlerts />
      <Header />

      <div
        className="container mx-auto p-4 lg:p-8"
      >
        <Router />
      </div>
    </div>
  );
}

export default App;
