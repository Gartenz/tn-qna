require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of answer
  I'd like to be able edit my answer
} do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given(:another_user) { create(:user) }

  scenario 'Unauthenticated user can not edit answer', js: true do
    visit questions_path(question)

    expect(page).to_not have_link('Edit')
  end

  describe 'Authenticated user' do
    scenario 'edits his answer', js: true do
      sign_in user
      visit question_path(question)

      click_on 'Edit'

      within '.answers' do
        fill_in 'Body', with: 'edited answer'
        attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]

        click_on 'Update'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his answer with errors', js: true do
      sign_in user
      visit question_path(question)

      click_on 'Edit'

      within '.answers' do
        fill_in 'Body', with: ''
        click_on 'Update'

      end
      expect(page).to have_content "Body can't be blank"
    end

    scenario "tries to edit other user's answer", js: true do
      sign_in another_user

      visit question_path(question)

      expect(page).to_not have_link('Edit')
    end
  end
end
