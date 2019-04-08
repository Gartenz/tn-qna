require 'rails_helper'

feature 'User can sign up', %q{
  In order to sign in
  I'd like to be able to sign up
} do

  background { visit new_user_registration_path }

  scenario 'New user tries to sign up' do
    fill_in 'Email', with: 'user@test.ru'
    fill_in 'Password', with: '1234567'
    fill_in 'Password confirmation', with: '1234567'
    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'Already existed user tries to sign up' do
    user = create(:user)

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password
    click_on 'Sign up'

    expect(page).to have_content 'Email has already been taken'
  end
end
