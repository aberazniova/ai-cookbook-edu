---
applyTo: 'backend/'
---

## Backend Best Practices

- Use descriptive, domain-driven names for classes and files.
- Follow Rails conventions for file and class naming.

### Formatting
- prefer double quotes for strings in Ruby files (including tests and factories).

### Controllers
- Controllers should be thin: accept input, validate/permit parameters, delegate business work to service objects or models, and render responses using serializers.

### Service Objects
- Use service objects to encapsulate business logic.
- Place service objects in `app/services/` and use the Callable pattern (see `service_objects.instructions..md`).

### Serializers
- Use Active Model Serializers to shape JSON responses.
- Place serializers in `app/serializers/`.
- Keep serialization logic focused on presentation: attribute selection, formatting, and inclusion of associations.
- Avoid putting heavy computation or business logic in serializers; compute those values in service objects or models and pass them to serializers.

### Policies
- This project uses Pundit for authorization.
- Place policy classes in `app/policies/` and keep authorization rules focused and small.
- Use policy methods (for example: `show?`, `update?`, `destroy?`) and a `scope` for collection access control.

### Models
- Use model callbacks sparingly; prefer explicit service orchestration for multi-step processes.
- Use scopes to encapsulate common query patterns and improve readability.
