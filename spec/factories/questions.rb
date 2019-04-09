FactoryBot.define do
  factory :question do
    title { "MyString" }
    body { "MyText" }

    trait :with_author do
      author { create(:user) }
    end

    trait :invalid do
      title { nil }
    end
  end
end
