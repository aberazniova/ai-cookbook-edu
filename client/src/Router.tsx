import { Routes, Route } from 'react-router-dom';

import Recipe from 'pages/Recipe/Recipe';
import Home from 'pages/Home/Home';
import NotFound from 'pages/NotFound/NotFound';
import SignIn from 'pages/SignIn/SignIn';
import SignUp from 'pages/SignUp/SignUp';
import WithChat from 'layouts/WithChat';
import RequireAuth from 'layouts/RequireAuth';

function Router() {
  return (
    <>
      <Routes>
        <Route path="/sign-in" element={<SignIn />} />
        <Route path="/sign-up" element={<SignUp />} />
        <Route path="*" element={<NotFound />} />

        <Route element={<RequireAuth />}>
          <Route element={<WithChat />}>
          <Route path="/" element={<Home />} />
            <Route path="/recipes/*">
              <Route path=":id" element={<Recipe />} />
            </Route>
          </Route>
        </Route>
      </Routes>
    </>
  );
}

export default Router;
