import { Outlet } from 'react-router-dom';
import Header from 'components/Header/Header';
import GlobalAlerts from 'components/Common/Alert/GlobalAlerts';

export default function BaseLayout() {
  return (
    <>
      <div className='flex flex-col h-screen bg-cream overflow-hidden'>
        <Header />
        <GlobalAlerts />

        <main className="flex-1 flex overflow-hidden">
          <Outlet />
        </main>
      </div>
    </>
  );
}
