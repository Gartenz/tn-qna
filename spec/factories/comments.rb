FactoryBot.define do
  factory :comment do
    user { create(:user) }
    body { "MyString" }

    trait :for_question do
      association(:commentable, factory: :question)
    end

    trait :for_answer do
      association(:commentable, factory: :answer)
    end

    trait :invalid do
      body { nil }
    end
  end
end
