FactoryBot.define do
  factory :recipe do
    title { Faker::Food.dish }
    instructions { Faker::Lorem.paragraph(sentence_count: 5) }

    trait :with_ingredients do
      after(:create) do |recipe|
        create_list(:ingredient, 3, recipe: recipe)
      end
    end
  end
end
