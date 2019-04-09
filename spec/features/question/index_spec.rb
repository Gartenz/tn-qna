require 'rails_helper'

feature 'List questions', %q{
  if users want to create non duplicant question
} do
  given!(:questions) { create_list(:question, 3, :with_author) }

  describe 'Authenticated user' do
    given(:user) { create(:user) }

    background { sign_in(user) }

    scenario 'wants to see list of questions' do
      visit questions_path

      expect(page).to have_content questions[0].title
    end

  end

  scenario 'Unauthenticated user wants to see list of questions' do
    visit questions_path

    expect(page).to have_content questions[0].title
  end
end
