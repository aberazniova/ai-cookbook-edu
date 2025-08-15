import { Button } from 'flowbite-react';
import { HiArrowSmLeft } from 'react-icons/hi';

function NotFound() {
  return (
    <div className="flex items-center justify-center px-4 my-10">
      <div className="text-center">
        <h1 className="mb-2 text-3xl tracking-tight font-extrabold text-gray-800 md:text-4xl dark:text-gray-100">
          Oops!
        </h1>
        <p className="mb-4 text-7xl tracking-tight font-extrabold lg:text-9xl text-emerald-600 dark:text-emerald-400">
          404
        </p>
        <p className="mb-4 text-3xl tracking-tight font-bold text-gray-800 md:text-4xl dark:text-gray-100">
          Page not found
        </p>
        <p className="mb-6 text-lg font-light text-gray-500 dark:text-gray-400">
          We are sorry but the page you requested was not found.
        </p>
        <Button
          href="/"
          size="lg"
          className="mt-6 inline-flex items-center text-white bg-emerald-600 hover:bg-emerald-700 focus:ring-4 focus:ring-emerald-300
            font-medium rounded-lg text-sm px-5 py-2.5 text-center dark:bg-emerald-500 dark:hover:bg-emerald-600 dark:focus:ring-emerald-900"
        >
          <HiArrowSmLeft className="mr-2 h-5 w-5" />
          Go to Homepage
        </Button>
      </div>
    </div>
  );
}

export default NotFound;
