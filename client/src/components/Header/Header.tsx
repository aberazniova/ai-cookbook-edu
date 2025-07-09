import { Navbar, NavbarBrand, NavbarToggle, Avatar } from "flowbite-react";
import { FaUtensils } from 'react-icons/fa';
import { Link } from 'react-router-dom';

function Header() {
  return (
    <div className="bg-white dark:bg-neutral-900 shadow-xl">
      <div className="container mx-auto px-2 sm:px-4 lg:px-8">
        <Navbar fluid rounded={false} className="bg-white dark:bg-neutral-900 py-4 lg:py-5">
          <NavbarBrand>
            <Link to="/" className="flex items-center">
              <span className="self-center whitespace-nowrap text-3xl lg:text-4xl font-extrabold text-transparent bg-clip-text bg-gradient-to-r
 from-emerald-600 to-orange-500 dark:from-emerald-400 dark:to-orange-300 mr-2">
                The Cookbook
              </span>
              <FaUtensils className="text-xl lg:text-2xl text-orange-500 dark:text-orange-300" />
            </Link>
          </NavbarBrand>
          <div className="flex md:order-2">
            <Avatar img="https://flowbite.com/docs/images/people/profile-picture-5.jpg" rounded />
            <NavbarToggle />
          </div>
        </Navbar>
      </div>
    </div>
  );
}

export default Header;
