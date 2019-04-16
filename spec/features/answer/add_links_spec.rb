require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additioanal info to my answer
  I'd like to be able to add links
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:simple_url) { 'https://google.com' }
  given(:gist_url) { 'https://gist.github.com/Gartenz/2b300505c12cf48e38c95d00edb7fd0b' }
  given(:invalid_url) { 'gist/Gartenz/2b300505c12cf48e38c95d00edb7fd0b' }

  describe 'Authenticated user' do
    background do
      sign_in user
      visit question_path(question)
    end

    scenario 'adds link when give an answer', js: true do
      within '.new-answer' do
        fill_in 'Body', with: 'Test text question'
        fill_in 'Link name', with: 'My link'
        fill_in 'Url', with: simple_url

        click_on 'Add answer'
      end

      within '.answers' do
        expect(page).to have_link 'My link', href: simple_url
      end
    end

    scenario 'adds gist link when give an answer', js: true do
      within '.new-answer' do
        fill_in 'Body', with: 'Test text question'
        fill_in 'Link name', with: 'My gist'
        fill_in 'Url', with: gist_url

        click_on 'Add answer'
      end

      within '.answers' do
        expect(page).to have_link 'My gist', href: gist_url
        expect(page).to have_content 'My gist content'
      end
    end

    scenario 'adds invalid link when give an answer', js: true do
      within '.new-answer' do
        fill_in 'Body', with: 'Test text question'
        fill_in 'Link name', with: 'My gist'
        fill_in 'Url', with: invalid_url

        click_on 'Add answer'
      end

      expect(page).to have_content 'Links url is not a valid HTTP URL'
    end
  end
end
