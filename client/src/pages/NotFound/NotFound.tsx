import { Link } from 'react-router-dom';
import { HiArrowSmLeft } from 'react-icons/hi';

function NotFound() {
  return (
    <div className="flex-1 pb-[10rem] content-center">
      <div className="flex items-center justify-center px-4 my-10">
        <div className="text-center">
          <h1 className="mb-2 text-3xl tracking-tight font-extrabold text-gray-800 md:text-4xl dark:text-gray-100">
            Oops!
          </h1>
          <p className="mb-4 text-7xl tracking-tight font-extrabold lg:text-9xl text-sage-green">
            404
          </p>
          <p className="mb-4 text-3xl tracking-tight font-bold text-gray-800 md:text-4xl dark:text-gray-100">
            Page not found
          </p>
          <p className="mb-6 text-lg font-light text-gray-500 dark:text-gray-400">
            We are sorry but the page you requested was not found.
          </p>
          <Link
            to="/"
            className={`
              mt-6 inline-flex items-center text-white bg-sage-green hover:bg-sage-green-800 focus:ring-4 focus:ring-sage-green-200
              font-medium rounded-lg text-sm px-5 py-2.5 text-center dark:bg-sage-green dark:hover:bg-sage-green dark:focus:ring-sage-green-800
            `}
          >
            <HiArrowSmLeft className="mr-2 h-5 w-5" />
            Go to Homepage
          </Link>
        </div>
      </div>
    </div>
  );
}

export default NotFound;
