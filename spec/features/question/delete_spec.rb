require 'rails_helper'

feature 'Only author can delete his own questions', %q{
  In order to maintain good relationship with other users
} do
  given(:question) { create(:question) }

  scenario 'Author tries to delete his own question' do
    sign_in(question.user)

    visit questions_path
    expect(page).to have_content question.title
    expect(page).to have_content question.body

    visit question_path(question)
    within '.card' do
      click_on 'Delete'
    end
    
    expect(page).to have_content 'Question deleted successfully.'
    expect(page).to_not have_content question.title
    expect(page).to_not have_content question.body
  end

  scenario 'Author tries to delete another user question' do
    user = create(:user)
    sign_in(user)

    visit question_path(question)

    expect(page).to_not have_link('Delete')
  end

  scenario 'Unauthenticated user tries to delete question' do
    visit question_path(question)

    expect(page).to_not have_link('Delete answer')
  end
end
