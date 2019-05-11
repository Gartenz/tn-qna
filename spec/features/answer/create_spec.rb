require 'rails_helper'

feature 'User can add answer for question on question page.' do
  given!(:question) { create(:question) }
  given(:user) { question.user }

  describe 'In multiple sessions', js: true do
    scenario 'Answer appears on another browser' do
      Capybara.using_session('user') do
        sign_in user
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within '.new-answer' do
          fill_in :Body, with: "New answer"
        end

        click_on 'Add answer'
        expect(page).to have_content 'New answer'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'New answer'
      end
    end
  end

  describe 'In single session' do
    context 'Authenticated user', js: true do
      background do
        sign_in(user)
        visit question_path(question)
      end

      scenario 'adds answer' do
        body = 'some text'

        within '.new-answer' do
          fill_in :Body, with: body
          click_on 'Add answer'
        end

        expect(page).to have_content body
      end

      scenario 'adds answer with errors' do
        click_on 'Add answer'

        expect(page).to have_content "Body can't be blank"
      end

      scenario 'answers with files' do
        within '.new-answer' do
          fill_in 'Body', with: 'text text'
          attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
          click_on 'Add answer'
        end

        within '.answers'do
          expect(page).to have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'
        end
      end
    end

    scenario "Unauthenticated user can't add answer" do
      visit question_path(question)

      within '.new-answer' do
        fill_in :Body, with: 'some text'
        click_on 'Add answer'
      end

      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end
end
