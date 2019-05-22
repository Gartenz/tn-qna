FactoryBot.define do
  sequence :title do |n|
    "My Title String #{n}"
  end

  factory :question do
    title
    body { "MyText" }
    user

    trait :with_reward do
      reward { create(:reward) }
    end

    trait :with_links do
      links { create_list(:link, 2, :for_question) }
    end

    trait :with_file do
      files { fixture_file_upload(Rails.root.join('spec','rails_helper.rb')) }
    end

    trait :with_comments do
      comments { create_list(:comment, 2, :for_question) }
    end

    trait :invalid do
      title { nil }
    end

    factory :question_with_all_appends, traits: %i[with_reward with_links with_file with_comments]
  end
end
