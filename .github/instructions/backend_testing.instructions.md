---
applyTo: 'backend/spec'
---

# Backend Testing Rules

## Framework & Organization
- Use RSpec with its modern syntax
- Follow Rails testing conventions for file organization
- Use appropriate RSpec matchers for readability

## Test Structure & Naming
- Describe methods using Ruby documentation conventions: `.` for class methods, `#` for instance methods
- Use contexts starting with 'when', 'with', or 'without' to organize tests clearly
- Write clear, concise spec descriptions (prefer shorter when clarity isn't sacrificed)

### Good Examples:
```ruby
# Good: Clear method description with proper convention
describe '#authenticate' do
  context 'when credentials are valid' do
    it 'returns the user' do
      # test implementation
    end
  end

  context 'when credentials are invalid' do
    it 'returns nil' do
      # test implementation
    end
  end
end

# Good: Concise but descriptive
describe '.pending' do
  it 'returns orders with pending status' do
    # test implementation
  end
end
```

### Bad Examples:
```ruby
# Bad: Vague description
it 'displays correct data' do
  # test implementation
end

# Bad: Too verbose
it 'returns a collection of order objects that have a status attribute set to the string value of "pending"' do
  # test implementation
end
```

## Comprehensive Testing
- Test all possible cases: valid, edge, and invalid cases
- Consider boundary conditions and error scenarios
- Test both happy path and error paths

## Test Data Management
- Use FactoryBot for test data creation with `create()` and `build()` syntax
- Create only the data needed for each test
- Use `let` for lazy-loaded variables, `let!` for immediate evaluation.

```ruby
  let!(:user) { create(:user) }  # Created immediately
  let(:post) { build(:post) }    # Created when first used
```

## Mocking & Dependencies
- Test real behavior when possible, mock external services and dependencies
- Don't over-use mocks

### Good Examples:
```ruby
# Good: Mocking external service
describe PaymentService do
  let(:payment_gateway) { instance_double('PaymentGateway') }
  let(:service) { PaymentService.new(payment_gateway) }

  before do
    allow(payment_gateway).to receive(:process).and_return({ success: true })
  end

  it 'processes payment successfully' do
    result = service.process_payment(amount: 100)
    expect(result.success?).to be true
  end
end
```

### Bad Examples:
```ruby
# Bad: Over-mocking internal behavior
describe User do
  let(:user) { build(:user) }

  it 'has a name' do
    allow(user).to receive(:first_name).and_return('John')
    allow(user).to receive(:last_name).and_return('Doe')
    allow(user).to receive(:full_name).and_return('John Doe')

    expect(user.full_name).to eq('John Doe')
  end
end
```

## Use of `subject`
- Use `subject` to define the object or method output under test. This makes tests more concise and readable, especially with one-line matchers.

### Good Examples:
```ruby
# Good: Using subject for the object
describe User do
  subject(:user) { build(:user, first_name: 'John', last_name: 'Doe') }

  it 'has a first name' do
    expect(user.first_name).to eq('John')
  end

  describe '#full_name' do
    # subject is implicitly user.full_name
    subject { user.full_name }
    it { is_expected.to eq('John Doe') }
  end
end
```

### Bad Examples:
```ruby
# Bad: Repetitive calls without subject
describe User do
  it 'has a first name' do
    user = build(:user, first_name: 'John', last_name: 'Doe')
    expect(user.first_name).to eq('John')
  end

  describe '#full_name' do
    it 'returns the full name' do
      user = build(:user, first_name: 'John', last_name: 'Doe')
      expect(user.full_name).to eq('John Doe')
    end
  end
end
```

## Clarity with Named Subject
- Use a named subject when it improves clarity, allowing you to refer to the subject by a descriptive name.

### Good Examples:
```ruby
# Good: Using a named subject for clarity
describe User, type: :model do
  subject(:admin) { described_class.new(role: 'admin') }

  it 'is an admin' do
    expect(admin).to be_admin
  end
end
```

### Bad Examples:
```ruby
# Bad: Using a generic subject name
describe User, type: :model do
  subject { described_class.new(role: 'admin') }

  it 'is an admin' do
    expect(subject).to be_admin
  end
end
```

## Single Assertions
- Each test should make only one assertion for clarity and easier debugging
- Focus on testing one specific behavior per test

### Good Examples:
```ruby
# Good: Single assertion, clear test
describe User, '#full_name' do
  let(:user) { build(:user, first_name: 'John', last_name: 'Doe') }
  
  it 'returns concatenated first and last name' do
    expect(user.full_name).to eq('John Doe')
  end
end

# Good: Multiple related tests for different scenarios
describe User, '#age' do
  context 'when birthday is today' do
    let(:user) { build(:user, birth_date: Date.current) }
    
    it 'returns 0' do
      expect(user.age).to eq(0)
    end
  end
  
  context 'when birthday is in the future' do
    let(:user) { build(:user, birth_date: 1.year.from_now) }
    
    it 'returns nil' do
      expect(user.age).to be_nil
    end
  end
end
```

### Bad Examples:
```ruby
# Bad: Multiple assertions in one test
describe User, '#full_name' do
  let(:user) { build(:user, first_name: 'John', last_name: 'Doe') }
  
  it 'handles name formatting' do
    expect(user.full_name).to eq('John Doe')
    expect(user.full_name).to include('John')
    expect(user.full_name).to include('Doe')
    expect(user.full_name.length).to be > 0
  end
end
```

## Code Reuse
- Use shared examples to DRY up repetitive test patterns

### Good Examples:
```ruby
# Good: Shared examples for common behavior
RSpec.shared_examples 'validates presence' do |attribute|
  it "validates presence of #{attribute}" do
    object.send("#{attribute}=", nil)
    expect(object).not_to be_valid
    expect(object.errors[attribute]).to include("can't be blank")
  end
end

describe User do
  it_behaves_like 'validates presence', :email
  it_behaves_like 'validates presence', :username
end
```

### Bad Examples:
```ruby
# Bad: Repetitive test code
describe User do
  it 'validates presence of email' do
    user = build(:user, email: nil)
    expect(user).not_to be_valid
    expect(user.errors[:email]).to include("can't be blank")
  end
  
  it 'validates presence of username' do
    user = build(:user, username: nil)
    expect(user).not_to be_valid
    expect(user.errors[:username]).to include("can't be blank")
  end
end
```
