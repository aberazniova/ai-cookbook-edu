---
applyTo: '**'
---

# General Formatting Rules

- Always add a new line at the end of each file
- Use **2 spaces** for indentation in all code files

- Avoid shortening variable names; prefer clear, descriptive names (e.g. `user` instead of `usr`).
- Prefer descriptive names for methods, functions, and variables instead of adding comments to explain them.
- If a method or function becomes large or requires explanatory comments, split it into smaller pieces to keep code readable.

# Backend

- Always prefer double quotes for strings on the backend (including test files and factories)

# Frontend

- Always prefer single quotes for strings in JavaScript and TypeScript files

### File Naming and Extensions

- React Components & Files with JSX: Use the **.tsx** file extension for all files that contain React components or any form of JSX syntax. This ensures we are always writing type-safe code and enables proper syntax highlighting and tooling for both TypeScript and JSX.

Example **src/components/Button.tsx, src/testUtils/renderInRouter.tsx (if it contains JSX)**

- Use the standard **.ts** extensions for all other TypeScript files that do not contain JSX.

Example: **src/utils/formatDate.ts, src/hooks/useFetchData.ts (if it does not contain JSX)**
