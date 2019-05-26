FactoryBot.define do
  factory :subscription do
    user { create(:user) }

    trait :for_question do
      association(:subscribable, factory: :question)
    end

    trait :for_answer do
      association(:subscribable, factory: :answer)
    end
  end
end
