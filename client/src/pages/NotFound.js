import { Link } from 'react-router-dom';

function NotFound() {
  return (
    <div>
      <h1>Oops!</h1>
      <h3>404 - Page not found</h3>
      <p>We are sorry but the page you requested was not found.</p>
      <Link to="/">Go to Homepage</Link>
    </div>
  );
}

export default NotFound;
