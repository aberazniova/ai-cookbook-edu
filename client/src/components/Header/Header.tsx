import { useState } from 'react';
import { Link } from 'react-router-dom';
import {
  FiBookOpen as BookOpen,
  FiUser as UserIcon,
  FiLogOut as LogOut,
  FiGlobe as Globe,
  FiMenu as Menu
} from 'react-icons/fi';
import { TbChefHat as ChefHat } from 'react-icons/tb';

import { useNavigate } from 'react-router-dom';
import { useAuthStore } from 'stores/authStore';
import { logout } from 'utils/auth';
import { useAlertStore } from 'stores/alertStore';
import { Dropdown, DropdownItem, DropdownDivider, DropdownHeader } from 'flowbite-react';

function Header() {
  const navigate = useNavigate();
  const user = useAuthStore((s) => s.user);
  const addAlert = useAlertStore((s) => s.addAlert);

  const [isMobileMenuOpen, setIsMobileMenuOpen] = useState(false);

  const navigationItems = [
    {
      title: 'My Recipes',
      url: '/',
      icon: BookOpen,
    },
    {
      title: 'Community Recipes',
      url: '/community-recipes',
      icon: Globe,
    },
  ];

  const handleLogout = async () => {
    try {
      await logout();
    } catch (error) {
      addAlert({ type: 'failure', message: error?.message || 'Failed to sign out' });
    }
    navigate('/sign-in');
  };

  return (
    <header className='flex items-center justify-between px-4 md:px-6 py-3 bg-white border-b shadow-sm z-10'>
      <Link to='/' className='flex items-center gap-3'>
        <div className='w-10 h-10 rounded-lg flex items-center justify-center bg-sage-green'>
          <ChefHat className='w-6 h-6 text-white' />
        </div>
        <h1 className='font-bold text-xl text-gray-900 hidden sm:block'>RecipeAI</h1>
      </Link>

      {user && (
        <>
          <nav className='hidden md:flex items-center gap-6'>
            {navigationItems.map((item) => (
              <Link key={item.title} to={item.url}>
                <button
                  className={`
                    justify-center whitespace-nowrap rounded-md text-sm font-medium ring-offset-background transition-colors
                    focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 
                    hover:bg-gray-100 hover:text-accent-foreground h-10 px-4 py-2 flex items-center gap-2
                  `}
                >
                  <item.icon className='w-4 h-4' />
                  {item.title}
                </button>
              </Link>
            ))}
          </nav>

          <div className='flex items-center gap-2'>
            <div className='md:hidden'>
              <button
                onClick={() => setIsMobileMenuOpen(true)}
                className='inline-flex items-center justify-center p-2 rounded-md text-gray-700 hover:bg-gray-100'
                aria-label='Open menu'
              >
                <Menu className='w-5 h-5' />
              </button>

              {isMobileMenuOpen && (
                <div className='fixed inset-0 z-40'>
                  <div className='absolute inset-0 bg-black/40' onClick={() => setIsMobileMenuOpen(false)} />
                  <div className='absolute left-0 top-0 bottom-0 w-72 bg-white p-4 overflow-y-auto shadow-lg'>
                    <div className='flex items-center gap-3 mb-6'>
                      <div className='w-8 h-8 rounded-lg flex items-center justify-center bg-sage-green'>
                        <ChefHat className='w-5 h-5 text-white' />
                      </div>
                      <div className='font-semibold'>RecipeAI</div>
                    </div>
                    <nav className='space-y-3'>
                      {navigationItems.map((item) => (
                        <Link key={item.title} to={item.url} onClick={() => setIsMobileMenuOpen(false)}>
                          <div className='flex items-center gap-3 p-3 rounded-md hover:bg-gray-50'>
                            <item.icon className='w-5 h-5' />
                            <span>{item.title}</span>
                          </div>
                        </Link>
                      ))}
                    </nav>
                  </div>
                </div>
              )}
            </div>

            <div className='relative'>
              <Dropdown
                renderTrigger={() => (
                  <button className='rounded-full' aria-haspopup='true' aria-expanded='false' data-testid='user-menu'>
                    <div className='w-10 h-10 rounded-full flex items-center justify-center bg-sage-green-200'>
                      <UserIcon className='w-5 h-5 text-sage-green' />
                    </div>
                  </button>
                )}
              >
                <DropdownHeader>
                  <div className='text-left'>
                    <p className='text-sm font-medium'>{user?.email}</p>
                    <p className='text-xs text-gray-500'>Welcome!</p>
                  </div>
                </DropdownHeader>
                <DropdownDivider />
                <DropdownItem onClick={handleLogout} data-testid='logout-button'>
                  <div className='flex items-center gap-2'>
                    <LogOut className='w-4 h-4' />
                    <span>Log out</span>
                  </div>
                </DropdownItem>
              </Dropdown>
            </div>
          </div>
        </>
      )}
    </header>
  );
}

export default Header;
