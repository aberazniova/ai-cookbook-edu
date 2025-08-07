---
applyTo: 'backend/spec/**'
---

# Backend Testing Guidelines

Welcome! Use these guidelines to write clear, maintainable, and effective backend tests for this project.

---

## Framework & Organization
- Use **RSpec** with modern syntax.
- Follow Rails conventions for test file organization.
- Prefer readable RSpec matchers.

---

## Test Structure & Naming
- Describe methods using Ruby conventions: `.` for class methods, `#` for instance methods.
- Use contexts starting with **'when'**, **'with'**, or **'without'**.
- Write concise, clear spec descriptions.

**Good Examples:**
```ruby
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

describe '.pending' do
  it 'returns orders with pending status' do
    # test implementation
  end
end
```

**Bad Examples:**
```ruby
it 'displays correct data' do
  # test implementation
end

it 'returns a collection of order objects that have a status attribute set to the string value of "pending"' do
  # test implementation
end
```

---

## Comprehensive Testing
- Test valid, edge, and invalid cases.
- Consider boundary conditions and error scenarios.
- Cover both happy and error paths.

---

## Test Data Management
- Use FactoryBot for test data (`create`, `build`).
- Only create data needed for each test.
- Use `let` for lazy-loaded variables, `let!` for immediate evaluation.

```ruby
let!(:user) { create(:user) }
let(:post) { build(:post) }
```

---

## Mocking & Dependencies
- Prefer real behavior; mock only external services and dependencies.
- Avoid over-mocking.

**Good Example:**
```ruby
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

**Bad Example:**
```ruby
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

---

## Single Assertions
- Each test should make only one assertion.
- Focus on one specific behavior per test.

**Good Examples:**
```ruby
describe User, '#full_name' do
  let(:user) { build(:user, first_name: 'John', last_name: 'Doe') }
  it 'returns concatenated first and last name' do
    expect(user.full_name).to eq('John Doe')
  end
end

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

**Bad Example:**
```ruby
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

---

## Code Reuse
- Use shared examples to DRY up repetitive test patterns.

**Good Example:**
```ruby
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

**Bad Example:**
```ruby
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
