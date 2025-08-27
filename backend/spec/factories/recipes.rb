FactoryBot.define do
  factory :recipe do
    association :user
    title { Faker::Food.dish }
    instructions { Faker::Lorem.paragraph(sentence_count: 5) }
    difficulty { %w[easy medium hard].sample }
    summary { Faker::Lorem.sentence }
    cooking_time { Faker::Number.between(from: 10, to: 120) }
    servings { Faker::Number.between(from: 1, to: 10) }

    trait :with_ingredients do
      after(:create) do |recipe|
        create_list(:ingredient, 3, recipe: recipe)
      end
    end
  end
end
