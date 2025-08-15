import { create } from 'zustand';
import { combine } from 'zustand/middleware';
import { randomUid } from 'utils/randomUid';

const REMOVE_ALERT_DELAY = 8000;

export type AlertType = 'success' | 'failure' | 'warning' | 'info';

export type Alert = {
  id: string;
  type: AlertType;
  message: string;
};

type AlertStoreState = {
  alerts: Alert[];
};

type AlertStoreActions = {
  addAlert: (alert: Omit<Alert, 'id'>) => void;
  removeAlert: (id: string) => void;
  clearAlerts: () => void;
};

type AlertStore = AlertStoreState & AlertStoreActions;

export const useAlertStore = create<AlertStore>(
  combine({ alerts: [] }, (set) => {
    const removeAlert = (id: string) => {
      set((state) => ({
        alerts: state.alerts.filter((alert) => alert.id !== id),
      }));
    };

    const addAlert = (alert: Omit<Alert, 'id'>) => {
      const id = randomUid();
      const newAlert = { ...alert, id } as Alert;

      set((state) => ({
        alerts: [...state.alerts, newAlert],
      }));

      setTimeout(() => {
        removeAlert(id);
      }, REMOVE_ALERT_DELAY);
    };

    const clearAlerts = () => {
      set(() => ({
        alerts: [],
      }));
    };

    return {
      addAlert,
      removeAlert,
      clearAlerts,
    };
  }),
);
