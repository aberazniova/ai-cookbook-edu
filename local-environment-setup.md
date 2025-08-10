# Local Development Setup

This project consists of a **backend** (Rails API) and a **frontend** (React/TypeScript). Follow the instructions below to set up and run both parts locally.

---

## Prerequisites

- **MySQL**: Version 8.x recommended
- **Ruby**: Version 3.4.4
- **Bundler**: Install with `gem install bundler`
- **Node.js**: Version 18.x or higher recommended
- **npm**: Comes with Node.js

---

## Backend Setup

First, change into the `backend` directory.
Then follow these steps:

1. **Install Ruby dependencies:**
   ```sh
   bundle install
   ```

2. **Create your environment file:**  
   Copy the provided .env.example file and fill in your actual credentials:
   ```sh
   cp .env.example .env
   ```
   Edit `.env` and replace the placeholder values with your actual MySQL username, password, and any other required secrets.

3. **Set up environment variables:**  
   Set the `DB_USERNAME` and `DB_PASSWORD` environment variables to match your MySQL user and password.

4. **Set up the database:**  
   Rails will create the databases as specified in `config/database.yml` and load the schema from `db/schema.rb`.
   ```sh
   rails db:create db:schema:load
   ```

5. **Run the backend server:**
   ```sh
   rails s
   ```

---

## Frontend Setup

First, change into the `client` directory.
Then follow these steps:

1. **Install dependencies:**
   ```sh
   npm install
   ```

2. **Start the frontend development server:**
   ```sh
   npm start
   ```

3. **Create your environment file:**
   Create a `.env.development.local` file in the `client` directory with the following content:
   ```env
   REACT_APP_API_URL="http://localhost:3000/api/v1"
   ```
   If your backend runs on a different port, replace the value accordingly.

---

## Running Tests

### Backend (RSpec)
```sh
cd backend && rspec
```

### Frontend (Vitest)
```sh
cd client && npm run test
```

---

## Linting
- Frontend uses ESLint (`cd client && npm run lint`).
- Backend uses RuboCop (`cd backend && rubocop`).

---
