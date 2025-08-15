import { useEffect, useState } from 'react';
import { Outlet, useNavigate } from 'react-router-dom';
import { useAuthStore } from 'stores/authStore';

function RequireAuth() {
  const user = useAuthStore((s) => s.user);
  const token = useAuthStore((s) => s.token);

  const [verifiedAuth, setVerifiedAuth] = useState(false);

  const navigate = useNavigate();

  useEffect(() => {
    if (!user || !token) {
      navigate('/sign-in', { replace: true });
    } else {
      setVerifiedAuth(true);
    }
  }, [user, token, navigate]);

  return (
    <>
      {verifiedAuth ? <Outlet /> : null}
    </>
  );
}

export default RequireAuth;
