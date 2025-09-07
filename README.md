# AI Cookbook

Smart cookbook web application powered by Google Gemini.

This repository contains a Rails-based API backend and a React + TypeScript frontend of a single-page cookbook application that integrates with Google Gemini LLM leveraging its function-calling capabilities.

## Overview

The app provides the user interface for browsing recipes and interacting with the AI assistant.

The assistant at the core of the app is designed to help users with everything cooking-related: answering questions, guiding users through cooking process, creating and updating recipes in the database, searching and suggesting recipes, inventing new recipe ideas based on ingredients, dietary preferences, and more.

The app leverages Google Gemini API's function calling capabilities. The model interacts with the recipe application through a set of server-side function entrypoints that allow it to provide rich, contextual guidance. The assistant can flexibly combine multiple function calls to fulfill complex user requests.

Here is a quick demo

https://github.com/user-attachments/assets/84da8bd1-f79a-4227-9a66-1a6b2f400ae8

You can try it out here https://ai-cookbook-edu.vercel.app.
> **Note:** Render free-plan instances spin down after inactivity, it may delay the first request by ~50 seconds.

## Tech stack and design decisions

### Backend

- **Ruby on Rails** (API-only mode)
  - Architectural patterns: service objects and POROs, concerns to share logic, serializer layer for deterministic output, policy-based authorization using **Pundit**.
  - Testing: **RSpec** with unit tests for models and services, and request specs for API endpoints.
  - Database: **MySQL**

### Authentication

 - short lived JWT access tokens (**Device JWT**) + long lived rotatable refresh tokens
 - per-IP and per-account rate limiting on authentication endpoints (sign-in, sign-up, token refresh) to mitigate brute-force and abuse

### Frontend

- React + TypeScript
  - State management: lightweight **Zustand** stores under `src/stores`.
  - Routing: **React Router** for client-side routing. Reusable and composable layouts with the use of React Router V6 `Outlet`s encapsulate common UI layers and route protecting.
  - Styling: **Tailwind CSS** utility classes + **Flowbite** for accessible UI building blocks.
  - Testing: unit tests using **Vitest** + React Testing Library.

### AI integration

- Persisting conversation histroy
  - Conversation lifespan is limited to a browser session.
  - Performance: denormalized the database to keep retrieving conversation turns speedy for both UI display and building history for the model. Turn table stores full LLM payload (ready-to-send) alongside materialized columns (role and plain-text message) for display needs.

- Function calling
  - The backend exposes a small, well-typed set of function entrypoints. The LLM calls these functions to read and modify application state.
  - Iterative process of executing function calls and generating model responses allows for multi-turn tool usage within one user requested task.
  - Security & audit: strict parameter whitelisting, and auditable function-call handlers keeping all agent-initiated changes traceable (through logs and stored conversation turns).
  - Failure modes: passing informative error messages back to the model allows it to retry with the adjusted input or generate helpful responses to the user. Use of transactions to ensure multi-step operations are applied atomically allowing for idempotent retries.

## Local development (quickstart)

See [local-environment-setup.md](./local-environment-setup.md) for detailed local environment setup.
