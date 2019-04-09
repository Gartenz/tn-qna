require 'rails_helper'

feature 'User can add answer for question on question page.' do
  given!(:question) { create(:question, :with_author) }

  describe 'Authenticated user' do
    given(:user) { question.author }

    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'adds answer' do
      fill_in :Body, with: 'some text'
      click_on 'Add answer'

      expect(page).to have_content 'Answer was added successfully.'
    end

    scenario 'adds answer with errors' do
      click_on 'Add answer'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario "Unauthenticated user can't add answer" do
    visit question_path(question)

    fill_in :Body, with: 'some text'
    click_on 'Add answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end