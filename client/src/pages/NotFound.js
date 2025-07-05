import { Button } from 'flowbite-react';
import { HiArrowSmLeft } from 'react-icons/hi';

function NotFound() {
  return (
    <div className="flex items-center justify-center min-h-screen bg-gray-50 dark:bg-gray-900 px-4">
      <div className="text-center">
        <h1 className="mb-2 text-3xl tracking-tight font-extrabold text-gray-900 md:text-4xl dark:text-white">
          Oops!
        </h1>
        <p className="mb-4 text-7xl tracking-tight font-extrabold lg:text-9xl text-primary-600 dark:text-primary-500">
          404
        </p>
        <p className="mb-4 text-3xl tracking-tight font-bold text-gray-900 md:text-4xl dark:text-white">
          Page not found
        </p>
        <p className="mb-6 text-lg font-light text-gray-500 dark:text-gray-400">
          We are sorry but the page you requested was not found.
        </p>
        <Button
          href="/" // Link back to the homepage
          size="lg"
          className="mt-6 inline-flex items-center text-white bg-blue-700 hover:bg-blue-800 focus:ring-4 focus:ring-blue-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center dark:focus:ring-blue-900"
        >
          <HiArrowSmLeft className="mr-2 h-5 w-5" />
          Go to Homepage
        </Button>
      </div>
    </div>
  );
}

export default NotFound;
