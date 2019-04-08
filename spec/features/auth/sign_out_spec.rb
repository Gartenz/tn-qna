require 'rails_helper'

feature 'User can sign out', %q{
  In order to sign in in another account
} do
  scenario 'Registered user tries to sign out' do
    user = create(:user)
    sign_in(user)

    visit root_path

    click_on 'Sign out'

    expect(page).to have_content 'Signed out successfully.'
  end

  scenario 'Unregistered user tries to sign out' do
    visit root_path
    
    expect(page).to_not have_content 'Sign out'
  end
end
