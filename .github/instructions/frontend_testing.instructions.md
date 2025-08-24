---
applyTo: 'client/'
---

# Frontend Testing Instructions

## Test Setup and Configuration

- Use **React Testing Library** for rendering and interacting with components
- Use **Vitest** as the test runner and mocking library
- Files should be named `ComponentName.test.tsx` for React components

## Element Selection Strategy

- Use `data-testid` when the element cannot be reliably targeted built-in React Testing Library queries
- When using `data-testid` in tests, ensure the corresponding attribute is added to the component

### Test ID Format (when needed)
- Format: `{component-name}-{element-type}-{identifier}`
- Examples:
  ```tsx
  // Component file:
  <div data-testid='message-list-container'>
    {messages.map(msg => ...)}
  </div>

  // Test file:
  const container = screen.getByTestId('message-list-container');
  ```

### Test Structure
- Group related tests with `describe` blocks
- Use clear, descriptive test names
- Each test should focus on one specific behavior, prefer one expectation per `it` block
- Keep tests focused and easy to read

### User Interactions
- Use `@testing-library/user-event` instead of `fireEvent` for simulating user interactions
- This provides more realistic user interaction simulation including keyboard events, focus management, and input behaviors

### Mocking
- Use `vi.fn()` for mock functions
- Mock external dependencies and services
- Always mock fetch requests

### Router-aware Components
- Use the `renderWithRouter` utility from `utils/testUtils` when a component relies on React Router (e.g., `Link`, `NavLink`, `useNavigate`, `useParams`). This ensures the component is wrapped in a router context during tests.
- Example:
  ```tsx
  import { renderWithRouter } from 'utils/testUtils';
  
  renderWithRouter(<MyComponent />);
  ```

### Best Practices
- Test component behavior and interactions
- Verify component renders without crashing
- Test both success and error states
- Clean up after each test if needed
- Prefer single quotes

### Types
- Always use proper TypeScript types for test data and component props. Import shared types from `src/types/`.
- Avoid `any` and `as any` casts in tests.

### Props pattern in tests
- Prefer passing component props via a single base object and spread it in render. Override only the fields you need per test. This reduces duplication and keeps tests consistent.

Example:
```tsx
const baseProps = { title: 'Hello', disabled: false };
render(<Button {...baseProps} />);
render(<Button {...baseProps} disabled />);
```
