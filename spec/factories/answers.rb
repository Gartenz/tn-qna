FactoryBot.define do
  sequence :body do |n|
    "My awesome answer #{n}"
  end

  factory :answer do
    body
    user
    question

    trait :with_file do
      files { fixture_file_upload(Rails.root.join('spec','rails_helper.rb')) }
    end

    trait :invalid do
      body { nil }
    end
  end
end
