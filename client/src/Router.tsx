import { Routes, Route } from 'react-router-dom';

import Recipe from 'pages/Recipe';
import Home from 'pages/Home';
import NotFound from 'pages/NotFound';

function Router() {
  return (
    <>
      <Routes>
        <Route path="/" element={<Home />} />
        <Route path="/recipes/*">
          <Route path=":id" element={<Recipe />} />
        </Route>

        <Route path="*" element={<NotFound />} />
      </Routes>
    </>
  );
}

export default Router;
