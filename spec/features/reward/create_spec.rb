require 'rails_helper'

feature 'User can create reward for best answer', %q{
  In order to praise other users
  User can add reward to question
} do
  given(:user) { create(:user) }

  background do
    sign_in user
  end

  scenario 'Author can add reward while creating question' do
    visit new_question_path
    within '.question' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text'
    end
    within '.reward' do
      fill_in 'Title', with: 'Reward title'
      attach_file 'Image', "#{Rails.root}/tmp/pics/test.png"
    end

    click_on 'Create Question'

    expect(page).to have_content 'Your question successfully created'
  end
end
