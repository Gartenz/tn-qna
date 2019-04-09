FactoryBot.define do
  factory :answer do
    body { "MyText" }

    trait :with_question do
      question { create(:question, :with_author) }
    end

    trait :invalid do
      body { nil }
    end
  end
end
