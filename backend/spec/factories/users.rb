FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "pAssword123" }
    password_confirmation { "pAssword123" }
  end
end
