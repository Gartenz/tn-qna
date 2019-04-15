require 'rails_helper'

feature 'User can add links ti question', %q{
  In order to provide additioanal info to my question
  I'd like to be able to add links
} do
  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/Gartenz/2b300505c12cf48e38c95d00edb7fd0b' }

  scenario 'User adds link when asks question' do
    sign_in user
    visit new_question_path

    fill_in 'Title', with: 'Test title'
    fill_in 'Body', with: 'Test text question'
    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Create Question'

    expect(page).to have_link 'My gist', href: gist_url
  end
end
