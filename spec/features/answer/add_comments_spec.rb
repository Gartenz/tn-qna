require 'rails_helper'

feature 'User can add comment to answer', %q{
  In order to comment answer witout apply answser
  User can add comment to answer
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

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
        within "div[data-answer-id='#{answer.id}']"do
          fill_in 'Body', with: 'My comment'
          click_on 'Add comment'
        end

        within "div[id='answer-#{answer.id}-comments']" do
          expect(page).to have_content 'My comment'
        end
      end

      Capybara.using_session('guest') do
        within "div[id='answer-#{answer.id}-comments']" do
          expect(page).to have_content 'My comment'
        end
      end
    end
  end
end
