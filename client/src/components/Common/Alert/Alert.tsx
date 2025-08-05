import { Alert } from 'flowbite-react';
import { HiCheckCircle, HiExclamationCircle, HiInformationCircle, HiXCircle } from 'react-icons/hi';
import { type Alert as AlertType } from 'stores/alertStore';

type AlertProps = {
  alert: AlertType;
};

function AlertComponent({ alert }: AlertProps) {
  const getAlertIcon = () => {
    switch (alert.type) {
      case 'success':
        return HiCheckCircle;
      case 'failure':
        return HiXCircle;
      case 'warning':
        return HiExclamationCircle;
      case 'info':
        return HiInformationCircle;
      default:
        return HiInformationCircle;
    }
  };

  return (
    <Alert
      color={alert.type}
      className="mb-2"
      icon={getAlertIcon()}
    >
      <span>{alert.message}</span>
    </Alert>
  );
}

export default AlertComponent;
