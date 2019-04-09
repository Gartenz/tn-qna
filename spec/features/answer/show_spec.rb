require 'rails_helper'

feature 'User can see all answers fow required question.' do
  given(:answer) { create(:answer, :with_question, :with_author) }

  scenario 'Authenticated user can see question and answers' do
    user = create(:user)

    sign_in(user)

    visit question_path(answer.question)

    expect(page).to have_content answer.question.title
    expect(page).to have_content answer.body
  end

  scenario "Unauthenticated user can see question and answers" do
    visit question_path(answer.question)

    expect(page).to have_content answer.question.title
    expect(page).to have_content answer.body
  end
end
