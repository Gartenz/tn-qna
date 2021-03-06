require 'rails_helper'

feature 'Only author can delete his own answer', %q{
  In order to maintain good relationship with other users
} do
  given(:answer) { create(:answer) }

  scenario 'Author tries to delete his own answer', js: true do
    sign_in(answer.user)

    visit question_path(answer.question)

    expect(page).to have_content answer.body

    click_on 'Delete answer'

    expect(page).to_not have_content answer.body
  end

  scenario 'Author tries to delete another user answer' do
    user = create(:user)
    sign_in(user)

    visit question_path(answer.question)

    expect(page).to_not have_link('Delete answer')
  end

  scenario 'Unauthenticated user tries to delete answer' do
    visit question_path(answer.question)

    expect(page).to_not have_link('Delete answer')
  end
end
