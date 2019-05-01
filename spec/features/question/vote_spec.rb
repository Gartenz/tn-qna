require 'rails_helper'

feature 'User can vote for question', %q{
  In order to see what is best or worst question
  Users can vote for question
} do
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }
  given!(:owned_question) { create(:question, user: user) }

  given(:user) { create(:user) }


  scenario 'Unauthenticated user tries to vote' do
    visit question_path(question)

    within ".question-rating" do
      expect(page).to_not have_link('Vote up')
    end
  end

  context 'Authenticated user' do
    background do
      sign_in user
      visit question_path(question)
    end

    scenario 'tries to vote for his question' do
      visit question_path(owned_question)
      within ".question-rating" do
        expect(page).to_not have_link('Vote up')
      end
    end

    context 'as not an author tries' do
      scenario 'vote as positive to question', js: true do
        within ".question-rating" do
          click_on 'Vote up'

          expect(page).to have_content question.score
        end
      end
      scenario 'vote as negative to question', js: true do
        within ".question-rating" do
          click_on 'Vote down'

          expect(page).to have_content question.score
        end
      end

      scenario 'cancel vote', js: true do
        within ".question-rating" do
          click_on 'Vote down'

          expect(page).to have_content question.score
        end
      end
    end
  end
end
