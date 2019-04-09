require 'rails_helper'

feature 'Only author can delete his own answer', %q{
  In order to maintain good relationship with other users
} do
  given(:answer) { create(:answer, :with_question, :with_author) }

  scenario 'Author tries to delete his own answer' do
    sign_in(answer.author)

    visit question_path(answer.question)

    click_on 'Delete answer'

    expect(page).to have_content 'Answer deleted successfully.'
  end

  scenario 'Author tries to delete another user answer' do
    user = create(:user)
    sign_in(user)

    visit question_path(answer.question)

    expect(page).to_not have_link('Delete answer')
  end
end
