FactoryBot.define do
  sequence :uid do |n|
    "#{n}"
  end
  factory :authorization do
    user { create(:user) }
    provider { "my_provider" }
    uid

    trait :vk do
      provider { 'vkontakte' }
    end

    trait :github do
      provider { 'vkontakte' }
    end
  end

end
