---
applyTo: '**'
---

# Project Structure and Command Execution Rule

- Project’s directory structure:
  - The frontend code is located in the `client` directory.
  - The backend code is located in the `backend` directory.

- **Command Execution:**
  - For any frontend command (npm, yarn, vitest, vite, react-scripts, etc.), change into the `client` directory before executing the command.
    - Example: `cd client && npm install some-package`
  - For any backend command (rails, bundle, rspec, etc.), change into the `backend` directory before executing the command.
    - Example: `cd backend && bundle exec rspec`

- **General Principle:**
  - Always ensure the working directory is set to the appropriate subdirectory (`client` for frontend, `backend` for backend) before running any project-specific commands.
  - Always read the instructions documents for the corresponding directory, before generating or modifying any code. They are located in the `.github/instructions/` directory.

