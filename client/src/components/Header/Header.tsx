import {
  Navbar,
  NavbarBrand,
  NavbarToggle,
  Avatar,
  Dropdown,
  DropdownHeader,
  DropdownItem,
  Button
} from "flowbite-react";
import { FaUtensils } from 'react-icons/fa';
import { useNavigate } from 'react-router-dom';
import { useAuthStore } from 'stores/authStore';
import { logout } from 'utils/auth';
import { useAlertStore } from 'stores/alertStore';

function Header() {
  const navigate = useNavigate();
  const user = useAuthStore((s) => s.user);
  const addAlert = useAlertStore((s) => s.addAlert);

  const handleLogout = async () => {
    try {
      await logout();
    } catch (error) {
      addAlert({ type: 'failure', message: error?.message || 'Failed to sign out' });
    }
    navigate('/sign-in');
  };

  const renderUserMenu = () => {
    return (
      <Dropdown
        label={
          <span data-testid="user-menu">
            <Avatar
              img="https://flowbite.com/docs/images/people/profile-picture-5.jpg"
              rounded
            />
          </span>
        }
        arrowIcon={false}
        inline
      >
        <DropdownHeader>
          <span className="block text-sm">{user.email}</span>
        </DropdownHeader>
        <DropdownItem
          data-testid='logout-button'
          onClick={handleLogout}
          className='text-red-600 hover:text-red-700'
        >
          Logout
        </DropdownItem>
      </Dropdown>
    );
  }

  const renderSignInControls = () => {
    return (
      <div className="flex gap-2">
        <Button
          onClick={() => navigate('/sign-in')}
          className="bg-gray-100 hover:bg-gray-200 text-gray-900 dark:bg-neutral-700 dark:text-white"
        >
          Sign In
        </Button>
        <Button
          onClick={() => navigate('/sign-up')}
          className="bg-emerald-600 hover:bg-emerald-700 text-white"
        >
          Sign Up
        </Button>
      </div>
    );
  };

  return (
    <div className="bg-white dark:bg-neutral-900 shadow-xl">
      <div className="container mx-auto px-2 sm:px-4 lg:px-8">
        <Navbar fluid rounded={false} className="bg-white dark:bg-neutral-900 py-4 lg:py-5">
          <NavbarBrand 
            href="#" 
            className="flex items-center cursor-pointer"
            onClick={() => navigate('/')}
          >
            <span className="self-center whitespace-nowrap text-3xl lg:text-4xl font-extrabold text-transparent bg-clip-text bg-gradient-to-r
              from-emerald-600 to-orange-500 dark:from-emerald-400 dark:to-orange-300 mr-2">
              The Cookbook
            </span>
            <FaUtensils className="text-xl lg:text-2xl text-orange-500 dark:text-orange-300" />
          </NavbarBrand>
          <div className="flex md:order-2 items-center gap-3">
            {user ? renderUserMenu() : renderSignInControls()}
            <NavbarToggle />
          </div>
        </Navbar>
      </div>
    </div>
  );
}

export default Header;
