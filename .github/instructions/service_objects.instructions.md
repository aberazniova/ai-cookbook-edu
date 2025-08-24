---
applyTo: 'backend/'
---

# Service object best practices

- Use the Callable service pattern
  - Include the `Callable` concern in service classes. This provides the `.call` class method that instantiates and executes the service: `MyService.call(...)`.

- Use keyword arguments for parameters
  - Always accept inputs as keyword parameters in `initialize`, for example: `def initialize(some_param:, some_other_param:)`.
  - This improves clarity, prevents ordering mistakes, and simplifies future additions of optional args.

- Return explicit values
  - Return a clear, explicit result from the service. Do not rely on side-effects alone.
  - If multiple values are needed, prefer returning a small value object / `Struct` with named accessors (for example `Result = Struct.new(:value, :record)`).
  - Using a struct means callers can rely on named fields (e.g. `result.raw_token`) and not care about the order of returned values.

- Use attribute readers for instance variables you want to remain immutable.

  Example:

  ```ruby
  class SomeService
    def initialize(user:, ttl: 30.days)
      @user = user
      @ttl = ttl
    end

    private
    attr_reader :user, :ttl
  end
  ```

- Keep services single-responsibility
  - A service should do one thing: create, update, or compute a value. If logic grows, extract helper services.

- Style and structure
  - Files go under `app/services/...` and follow namespacing that mirrors the domain: e.g. `app/services/refresh_tokens/generate.rb`.
  - Keep `initialize` and `call` small and readable. Use private helper methods when necessary.
