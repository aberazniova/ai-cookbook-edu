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

    trait :multi_part_model_response do
      role { :model }
      text_content { [Faker::Lorem.sentence, Faker::Lorem.sentence].join("\n\n") }
      payload do
        {
          "parts" => [
            { "text" => text_content.split("\n\n").first },
            { "text" => text_content.split("\n\n").last }
          ]
        }
      end
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

    trait :function_and_text do
      role { :model }
      text_content { "Some reply" }
      payload do
        {
          "parts" => [
            { "text" => text_content },
            { "functionCall" => { "name" => "create_recipe", "args" => { "title" => "T" } } }
          ]
        }
      end
    end
  end
end
