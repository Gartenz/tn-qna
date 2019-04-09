require 'rails_helper'

feature 'Only author can delete his own questions', %q{
  In order to maintain good relationship with other users
} do
  given(:question) { create(:question) }

  scenario 'Author tries to delete his own question' do
    sign_in(question.user)

    visit question_path(question)

    click_on 'Delete'

    expect(page).to have_content 'Question deleted successfully.'
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
