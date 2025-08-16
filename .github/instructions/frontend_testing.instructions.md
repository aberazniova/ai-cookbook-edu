---
applyTo: 'client'
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
- Each test should focus on one specific behavior
- Keep tests focused and easy to read

### User Interactions
- Use `@testing-library/user-event` instead of `fireEvent` for simulating user interactions
- This provides more realistic user interaction simulation including keyboard events, focus management, and input behaviors

### Mocking
- Use `vi.fn()` for mock functions
- Mock external dependencies and services
- Always mock fetch requests

### Best Practices
- Test component behavior and interactions
- Verify component renders without crashing
- Test both success and error states
- Clean up after each test if needed
- Prefer single quotes
