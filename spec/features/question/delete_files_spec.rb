require 'rails_helper'

feature 'User can delete files from question', %q{
  In order to not confuse other users
  Or if he upload file by mistake
} do
  given!(:author) { create(:user) }
  given!(:question) { create(:question, :with_file, user: author) }
  given(:another_user) { create(:user) }

  scenario 'Unauthenticated user tries to edit question' do
    visit question_path(question)

    within '.question-files' do
      expect(page).to_not have_link 'Delete file'
    end
  end

  describe 'Authenticated user' do
    scenario 'as author deletes file', js: true do
      sign_in author
      visit question_path(question)

      filename = question.files.first.filename.to_s
      within '.question-files' do
        expect(page).to have_content filename
        click_on 'Delete file'
      end

      within '.question' do
        expect(page).to_not have_content filename
      end
    end

    scenario 'as non author tries to delete file' do
      sign_in another_user
      visit question_path(question)

      within '.question-files' do
        expect(page).to_not have_link 'Delete file'
      end
    end
  end
end
