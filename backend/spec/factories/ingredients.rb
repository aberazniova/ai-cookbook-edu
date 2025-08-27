FactoryBot.define do
  factory :ingredient do
    name { Faker::Food.ingredient }
    amount { Faker::Number.decimal(l_digits: 1, r_digits: 2) }
    unit { Faker::Food.measurement }
  end
end
