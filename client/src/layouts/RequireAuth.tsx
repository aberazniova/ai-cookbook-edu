import { useEffect, useState } from 'react';
import { Outlet, useNavigate } from 'react-router-dom';

import { useAuthStore } from 'stores/authStore';
import { refreshToken } from 'utils/auth';
import LoadingSpinner from 'components/Common/LoadingSpinner/LoadingSpinner';

function RequireAuth() {
  const { user, token } = useAuthStore();
  const [verifiedAuth, setVerifiedAuth] = useState(false);

  const navigate = useNavigate();

  useEffect(() => {
    const checkAuth = async () => {
      if (user && token) {
        setVerifiedAuth(true);
        return;
      }

      if (await refreshToken()) {
        setVerifiedAuth(true);
      } else {
        navigate('/sign-in');
      }
    };

    checkAuth();
  }, [user, token, navigate]);

  return (
    <>
      {verifiedAuth ? <Outlet /> : <LoadingSpinner />}
    </>
  );
}

export default RequireAuth;
