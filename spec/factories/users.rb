FactoryBot.define do
  sequence :email do |n|
    "user#{n}@test.ru"
  end

  factory :user do
    email
    password { '123456' }
    password_confirmation { '123456' }
  end

  trait :with_auth do
    authorizations { create_list(:authorization, 1) }
  end
end
