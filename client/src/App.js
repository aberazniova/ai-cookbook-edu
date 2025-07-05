import './App.css';
import { Routes, Route } from 'react-router-dom';

import RecipeDetails from './pages/RecipeDetails';
import Recipes from './pages/Recipes';
import Home from './pages/Home';
import NotFound from './pages/NotFound';

function App() {
  return (
    <>
      <Routes>
        <Route path="/" element={<Home />} />
        <Route path="/recipes/*">
          <Route index element={<Recipes />} />
          <Route path=":id" element={<RecipeDetails />} />
        </Route>

        <Route path="*" element={<NotFound />} />
      </Routes>
    </>
  );
}

export default App;
