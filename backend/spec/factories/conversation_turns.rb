FactoryBot.define do
  factory :conversation_turn do
    association :conversation

    role { :user }
    text_content { Faker::Lorem.sentence }
    payload { { "parts" => [{ "text" => text_content }] } }

    trait :user_message do
      role { :user }
      text_content { Faker::Lorem.sentence }
      payload { { "parts" => [{ "text" => text_content }] } }
    end

    trait :model_response do
      role { :model }
      text_content { Faker::Lorem.paragraph }
      payload { { "parts" => [{ "text" => text_content }] } }
    end

    trait :with_function_call do
      role { :model }
      text_content { nil }
      payload do
        {
          "parts" => [
            {
              "functionCall" => {
                "name" => "create_recipe",
                "args" => {
                  "title" => "Test Recipe",
                  "instructions" => "Test instructions"
                }
              }
            }
          ]
        }
      end
    end
  end
end
