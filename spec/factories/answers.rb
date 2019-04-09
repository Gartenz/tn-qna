FactoryBot.define do
  sequence :body do |n|
    "My awesome answer #{n}"
  end

  factory :answer do
    body
    user
    question

    trait :invalid do
      body { nil }
    end
  end
end
