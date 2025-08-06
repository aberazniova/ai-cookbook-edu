import { defineConfig } from 'vitest/config';
import path from 'path';

export default defineConfig({
  test: {
    environment: 'jsdom',
    globals: true,
    setupFiles: './src/setupTests.js',
  },
  resolve: {
    alias: {
      'components': path.resolve(__dirname, './src/components'),
      'utils': path.resolve(__dirname, './src/utils'),
      'types': path.resolve(__dirname, './src/types'),
      'stores': path.resolve(__dirname, './src/stores'),
      'pages': path.resolve(__dirname, './src/pages'),
    },
  },
});
