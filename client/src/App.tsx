import { ThemeProvider } from "flowbite-react";

import './App.css';
import Router from 'Router';
import { customTheme } from 'utils/customTheme'

function App() {
  return (
    <ThemeProvider theme={customTheme}>
      <Router />
    </ThemeProvider>
  );
}

export default App;
