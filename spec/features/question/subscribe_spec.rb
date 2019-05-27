require 'rails_helper'

feature 'Subscribe', %q{
  In order to receive mails of important questions
  Users can subscribe for question
} do
  given(:question) { create(:question) }


  scenario 'Unauthenticated user wants to subscribe' do
    visit question_path(question)

    within '.card' do
      expect(page).to_not have_link 'Subscribe'
    end
  end

  context 'Authenticated user', js: true do
    given(:user) { create(:user) }

    background do
      sign_in user
      visit question_path(question)
    end
    
    scenario 'tries to subscribe' do
      within '.question-body' do
        click_on 'Subscribe'

        expect(page).to_not have_link 'Unsubscribe'
      end
    end

    scenario 'tries to unsubscribe' do
      within '.question-body' do
        click_on 'Subscribe'
        click_on 'Unsubscribe'

        expect(page).to_not have_link 'Suscribe'
      end
    end
  end
end
