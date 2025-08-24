import type { ReactElement } from 'react';
import { render } from '@testing-library/react';
import { BrowserRouter, MemoryRouter, Routes, Route } from 'react-router-dom';

type RenderWithRouterOptions = {
  // Initial URL to render at (e.g., '/recipe/1')
  route?: string;
  // Route path to register when components rely on useParams (e.g., '/recipe/:id')
  path?: string;
};

export const renderWithRouter = (
  ui: ReactElement,
  options?: RenderWithRouterOptions
) => {
  const route = options?.route ?? '/';

  if (!options || (!options.route && !options.path)) {
    return render(<BrowserRouter>{ui}</BrowserRouter>);
  }

  if (options.path) {
    return render(
      <MemoryRouter initialEntries={[route]}>
        <Routes>
          <Route path={options.path} element={ui} />
        </Routes>
      </MemoryRouter>
    );
  }

  return render(<MemoryRouter initialEntries={[route]}>{ui}</MemoryRouter>);
};
