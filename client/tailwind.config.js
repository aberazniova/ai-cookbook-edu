/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./src/**/*.{js,jsx,ts,tsx}",
    "node_modules/flowbite-react/**/*.{js,jsx,ts,tsx}",
    "node_modules/flowbite/**/*.js",
  ],
  theme: {
    extend: {
      colors: {
        'sage-green': {
          DEFAULT: '#2D5A27',
          200: '#E8F5E9',
          400: '#d1ebd3ff',
          600: '#2D5A27',
          800: '#244b23ff',
        },
        terracotta: {
          DEFAULT: '#C65D00',
          200: '#FDF2E8',
          400: '#f3b881ff',
          600: '#C65D00',
          700: '#b45a0fff',
          800: '#8B3E00',
        },
        cream: '#FAF9F6',
      },
    },
  },
  plugins: [
    require('@tailwindcss/typography'),
    require('flowbite/plugin'),
  ],
}
