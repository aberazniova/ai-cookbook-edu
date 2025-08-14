import { Routes, Route } from 'react-router-dom';

import Recipe from 'pages/Recipe';
import Home from 'pages/Home';
import NotFound from 'pages/NotFound';
import SignIn from 'pages/SignIn/SignIn';
import SignUp from 'pages/SignUp/SignUp';

function Router() {
  return (
    <>
      <Routes>
        <Route path="/" element={<Home />} />
        <Route path="/sign-in" element={<SignIn />} />
        <Route path="/sign-up" element={<SignUp />} />
        <Route path="/recipes/*">
          <Route path=":id" element={<Recipe />} />
        </Route>

        <Route path="*" element={<NotFound />} />
      </Routes>
    </>
  );
}

export default Router;
