import { useAlertStore } from 'stores/alertStore';
import AlertComponent from './Alert';

function GlobalAlerts() {
  const alerts = useAlertStore((state) => state.alerts);

  if (alerts.length === 0) {
    return null;
  }

  return (
    <div className="fixed top-4 right-4 z-50 max-w-sm w-full space-y-2">
      {alerts.map((alert) => (
        <AlertComponent key={alert.id} alert={alert} />
      ))}
    </div>
  );
}

export default GlobalAlerts;
