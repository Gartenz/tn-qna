require 'rails_helper'

feature 'Author of question can mark answer', %q{
  In order to other users can see helped answer
  Author can mark one answer as best
} do
  given!(:author) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given!(:answers) { create_list(:answer, 3, question: question) }

  scenario 'Unauthenticated user tries to mark answer' do
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_link('Best')
    end
  end

  describe 'Authenticated user' do
    scenario 'as author marks answer as best', js: true do
      sign_in author
      visit question_path(question)
      page.find(:css,"div[data-answer-id='#{answers.last.id}']").click_on 'Best'

      within '.answers' do
        expect(page).to have_css('.best-answer')
      end
    end

    scenario 'as non author tries to mark best answer' do
      user = create(:user)
      sign_in user

      visit question_path(question)

      expect(page).to_not have_link('Best')
    end
  end
end
