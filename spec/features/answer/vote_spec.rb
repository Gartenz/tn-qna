require 'rails_helper'

feature 'User can vote for answer', %q{
  In order to see what is best or worst answer
  Users can vote for answers
} do
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }
  given!(:owned_answer) { create(:answer, user: user, question: question) }

  given(:user) { create(:user) }


  scenario 'Unauthenticated user tries to vote' do
    visit question_path(question)

    within "tr[data-answer-id='#{answer.id}']" do
      expect(page).to_not have_link('Vote up')
    end
  end

  context 'Authenticated user' do
    background do
      sign_in user
      visit question_path(question)
    end

    scenario 'tries to vote for his answer' do
      within ".answer-rating-#{owned_answer.id}" do
        expect(page).to_not have_link('Vote up')
      end
    end

    context 'as not an author tries' do
      scenario 'vote as positive to answer', js: true do
        within ".answer-rating-#{answer.id}" do
          expect(page).to have_content 0

          click_on 'Vote up'

          expect(page).to have_content 1
        end
      end
      scenario 'vote as negative to answer', js: true do
        within ".answer-rating-#{answer.id}" do
          expect(page).to have_content 0

          click_on 'Vote down'

          expect(page).to have_content -1
        end
      end

      scenario 'cancel vote', js: true do
        within ".answer-rating-#{answer.id}" do
          click_on 'Vote up'
          expect(page).to have_content 1

          click_on 'Cancel vote'

          expect(page).to have_content 0
        end
      end
    end
  end
end
