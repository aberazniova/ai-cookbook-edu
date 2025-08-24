---
applyTo: 'client/'
---

## Frontend Best Practices

- Write clear, descriptive variable, function, and component names. Avoid abbreviations.
- Keep functions and components small and focused. Extract logic to helpers or utilities when possible.

### Formatting
- prefer single quotes for strings in JavaScript and TypeScript files.

### Data Fetching
- Centralize API endpoints and request logic in utility files. This ensures consistency and easier maintenance. Do not fetch data directly in components.
- Store global state in Zustand stores (in `src/stores/`) when it needs to be shared across components.

### Extensions

- React Components & Files with JSX: Use the **.tsx** file extension for all files that contain React components or any form of JSX syntax. This ensures we are always writing type-safe code and enables proper syntax highlighting and tooling for both TypeScript and JSX.

Example **src/components/Button.tsx, src/testUtils/renderInRouter.tsx (if it contains JSX)**

- Use the standard **.ts** extensions for all other TypeScript files that do not contain JSX.

Example: **src/utils/formatDate.ts, src/hooks/useFetchData.ts (if it does not contain JSX)**

### Styling
- Use Tailwind CSS for styling components. Prefer utility classes over custom CSS when possible.
- Use Flowbite pre-built components when appropriate, and customize them to fit the common design of the application.

### TypeScript types & component props
- Declare shared types in `src/types/` and export them for reuse across components and utils.
- For component props prefer explicit interfaces and annotate the component parameters instead of relying on implicit `any` or `React.FC` defaulted props. Example pattern:

	```ts
	// src/components/Button.tsx
	interface ButtonProps {
		label: string
		onClick: () => void
		disabled: boolean
	}

	export default function Button({ label, onClick, disabled }: ButtonProps) {
		return (
			<button onClick={onClick} disabled={disabled}>{label}</button>
		)
	}
	```

- Use optional props (`?`) for values that are not required.

### Component and File Organization
- Place all React components in `src/components/` and use `.tsx` extension for files containing JSX.
- Place all utility functions in `src/utils/` and use `.ts` extension.
- Place all type definitions in `src/types/`.
- Place all page-level components in `src/pages/`.
- Place all layout components in `src/layouts/`.
