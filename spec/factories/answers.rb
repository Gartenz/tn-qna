FactoryBot.define do
  sequence :body do |n|
    "My awesome answer #{n}"
  end

  factory :answer do
    body
    user
    question

    trait :with_links do
      links { create_list(:link, 2, :for_answer) }
    end

    trait :with_file do
      files { fixture_file_upload(Rails.root.join('spec','rails_helper.rb')) }
    end

    trait :with_comments do
      comments { create_list(:comment, 2, :for_question) }
    end

    trait :invalid do
      body { nil }
    end

    factory :answer_with_all_appends, traits: %i[with_links with_file with_comments]
  end
end
