FactoryBot.define do
  factory :answer do
    body { "MyText" }
    question { FactoryBot.build(:question) }
  end
end
