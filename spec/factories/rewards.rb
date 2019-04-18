FactoryBot.define do
  factory :reward do
    title { "Question reward" }
    image { fixture_file_upload(Rails.root.join('tmp','pics','test.png')) }
    association(:question, factory: :question)
  end
end
