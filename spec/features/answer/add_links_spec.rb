require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additioanal info to my answer
  I'd like to be able to add links
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:gist_url) { 'https://gist.github.com/Gartenz/2b300505c12cf48e38c95d00edb7fd0b' }

  scenario 'User adds link when give an answer', js: true do
    sign_in user
    visit question_path(question)

    within '.new-answer' do
      fill_in 'Body', with: 'Test text question'
      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: gist_url

      click_on 'Add answer'
    end

    within '.answers' do
      expect(page).to have_link 'My gist', href: gist_url
    end
  end
end
