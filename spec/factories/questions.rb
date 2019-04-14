FactoryBot.define do
  sequence :title do |n|
    "My Title String #{n}"
  end

  factory :question do
    title
    body { "MyText" }
    user

    trait :with_file do
      files { fixture_file_upload(Rails.root.join('spec','rails_helper.rb')) }
    end

    trait :invalid do
      title { nil }
    end
  end
end
