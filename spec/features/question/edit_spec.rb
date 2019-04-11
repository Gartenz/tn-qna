require 'rails_helper'

feature 'User can edit his question', %q{
  In order to correct mistakes
  As an author of question
  I'd like to be able edit my question
} do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given(:another_user) { create(:user) }

  scenario 'Unauthenticated user tries to edit question' do
    visit question_path(question)

    within '.card' do
      expect(page).to_not have_link 'Edit'
    end
  end

  describe 'Authenticated user' do

    scenario 'edits his question', js: true do
      sign_in user
      visit question_path(question)
      within '.card' do
        click_on 'Edit'

        fill_in 'Title', with: 'edited awesome title'
        fill_in 'Body', with: 'edited awesome body'

        click_on 'Update'

        expect(page).to have_content 'edited awesome title'
        expect(page).to have_content 'edited awesome body'
      end
    end

    scenario 'edits his question with errors', js: true do
      sign_in user
      visit question_path(question)
      within '.card' do
        click_on 'Edit'

        fill_in 'Title', with: ''

        click_on 'Update'
      end
      expect(page).to have_content "Title can't be blank"
    end

    scenario "tries to edit other user's question" do
      sign_in another_user

      visit question_path(question)

      within '.card' do
        expect(page).to_not have_link 'Edit'
      end
    end
  end
end
