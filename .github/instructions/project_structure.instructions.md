---
applyTo: '**'
---

# Project Structure and Command Execution

- **Frontend code** is in the `client` directory.
- **Backend code** is in the `backend` directory.

## Command Execution

- For any frontend command (npm, yarn, vitest, vite, react-scripts, etc.), change into the `client` directory before running the command.
  - Example: `cd client && npm install some-package`
- For any backend command (rails, bundle, rspec, etc.), change into the `backend` directory before running the command.
  - Example: `cd backend && bundle exec rspec`

**Always ensure you are in the correct subdirectory (`client` for frontend, `backend` for backend) before running project-specific
