require 'rails_helper'

feature 'User can add comment to question', %q{
  In order to comment question iwtout apply answser
  User can add comment to question
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Using multiple sessions', js: true do
    scenario 'Comments appears on another browser' do
      Capybara.using_session('user') do
        sign_in user
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within '.new-question-comments' do
          fill_in 'Body', with: 'My commnet'
        end

        click_on 'Add comment'
        within '.question-comments' do
          expect(page).to have_content 'My commnet'
        end
      end

      Capybara.using_session('guest') do
        within '.question-comments' do
          expect(page).to have_content 'My commnet'
        end
      end
    end
  end
end
