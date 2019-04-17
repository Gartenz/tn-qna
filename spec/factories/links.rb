FactoryBot.define do
  sequence :name do |n|
    "My url name #{n}"
  end
  factory :link do
    name
    url { "https://github.com" }

    trait :for_answer do
      association(:linkable, factory: :answer)
    end

    trait :for_question do
      association(:linkable, factory: :question)
    end

    trait :with_invalid_link do
      url { 'http:/adasd' }
    end
  end
end
