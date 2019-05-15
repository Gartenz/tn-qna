FactoryBot.define do
  sequence :uid do |n|
    "#{n}"
  end
  factory :authorization do
    user { create(:user) }
    provider { "MyString" }
    uid
  end
end
