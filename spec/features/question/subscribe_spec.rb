require 'rails_helper'

feature 'Subscribe', %q{
  In order to receive mails of important questions
  Users can subscribe for question
} do
  given(:question) { create(:question) }

  background do
    visit question_path(question)
  end

  scenario 'Unauthenticated user wants to subscribe' do
    within '.card' do
      expect(page).to_not have_link 'Subscribe'
    end
  end

  context 'Authenticated user' do
    scenario 'tries to subscribe' do
      within '.card' do
        click_on 'Subscribe'

        expect(page).to_not have_link 'Unsubscribe'
      end
    end

    scenario 'tries to unsubscribe' do
      within '.card' do
        click_on 'Subscribe'
        click_on 'Unsubscribe'
        
        expect(page).to_not have_link 'Suscribe'
      end
    end
  end
end
