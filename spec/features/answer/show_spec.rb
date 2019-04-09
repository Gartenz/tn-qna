require 'rails_helper'

feature 'User can see all answers fow required question.' do
  given(:answers) { create_list(:answer, 3, question: create(:question)) }

  scenario 'Authenticated user can see question and answers' do
    user = create(:user)

    sign_in(user)

    visit question_path(answers.first.question)

    answers.each do |a|
      expect(page).to have_content a.body
    end
  end

  scenario "Unauthenticated user can see question and answers" do
    visit question_path(answers.first.question)

    answers.each do |a|
      expect(page).to have_content a.body
    end
  end
end
