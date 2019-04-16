FactoryBot.define do
  factory :link do
    name { "MyString" }
    url { "https://github.com" }
    linkable { create(:question) }
    
    trait :with_invalid_link do
      url { 'http:/adasd' }
    end
  end
end
