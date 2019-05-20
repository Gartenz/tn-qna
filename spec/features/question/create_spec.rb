require 'rails_helper'

feature 'User can create question', %q{
  In order to get answer from a community
  As an authenticated user
  I'd like to be able to ask the question
} do
  given(:user) { create(:user) }

  describe 'Using one session' do
    context 'Authenticated user' do
      background do
        sign_in(user)
        visit questions_path
        click_on 'Ask question'
      end

      scenario 'asks a question' do
        within '.question' do
          fill_in 'Title', with: 'Test question'
          fill_in 'Body', with: 'text text'
        end

        click_on 'Create Question'

        expect(page).to have_content 'Your question successfully created'
        expect(page).to have_content 'Test question'
        expect(page).to have_content 'text text'
      end

      scenario 'asks a question with errors' do
        click_on 'Create Question'

        expect(page).to have_content "Title can't be blank"
      end

      scenario 'asks question with attached file' do
        within '.question' do
          fill_in 'Title', with: 'Test question'
          fill_in 'Body', with: 'text text'
        end

        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Create Question'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'Unauthenticated user tries to ask a question' do
      visit questions_path
      click_on 'Ask question'

      expect(current_path).to eql(new_user_session_path)
    end
  end

  describe 'Using multiple sessions', js: true do
    scenario 'Question appears on another browser' do
      Capybara.using_session('user') do
        sign_in user
        visit questions_path
        click_on 'Ask question'
      end

      Capybara.using_session('guest') do
        visit questions_path
      end

      Capybara.using_session('user') do
        within '.question' do
          fill_in 'Title', with: 'Test question'
          fill_in 'Body', with: 'text text'
        end

        click_on 'Create Question'

        expect(page).to have_content 'Your question successfully created'
        expect(page).to have_content 'Test question'
        expect(page).to have_content 'text text'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Test question'
        expect(page).to have_content 'text text'
      end
    end
  end
end
