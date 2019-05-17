require 'rails_helper'

feature 'User can sign in', %q{
  In order to ask questions
  As an unauthenticated user
  I'd like to be able to sign in
} do

  given!(:user) { create(:user) }

  background { visit new_user_session_path }

  scenario 'Registered user tries to sign in' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'

    expect(page).to have_content 'Signed in successfully.'
  end

  scenario 'Unregistered user tries to sign in' do
    fill_in 'Email', with: 'wrong@test.com'
    fill_in 'Password', with: '123456'
    click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password.'
  end

  describe 'Using omniauth' do
    describe 'through vkontakte' do
      given!(:auth_with_comfirmed_user) { create(:authorization, :vk, user: create(:user, :confirmed)) }
      given!(:auth_with_uncomfirmed_user) { create(:authorization, :vk, user: create(:user)) }

      background do
        clear_emails
      end

      describe 'if user exists' do
        describe 'if user confirmed' do
          before do
            OmniAuth.config.mock_auth[:vkontakte][:uid] = auth_with_comfirmed_user.uid
            click_on 'Sign in with Vkontakte'
          end

          scenario 'sign in' do
            expect(page).to have_content auth_with_comfirmed_user.user.email
          end
        end

        describe 'if user not confirmed' do
          before do
            OmniAuth.config.mock_auth[:vkontakte][:uid] = auth_with_uncomfirmed_user.uid
            click_on 'Sign in with Vkontakte'
          end

          scenario 'Notice user about mail confirmation' do
            expect(page).to have_content 'You need to confirm your email'
          end
        end
      end

      describe 'if user does not exists' do
        scenario 'send confirmation email' do
          some_email = "some_email#{rand(0...10000)}@tests.ru"
          click_on 'Sign in with Vkontakte'

          fill_in 'Email', with: some_email
          click_on 'Continue'
          open_email(some_email)
          current_email.click_link 'Confirm my account'
          visit new_user_session_path
          click_on 'Sign in with Vkontakte'

          expect(page).to have_content some_email
        end
      end
    end

    describe 'through github' do
      given!(:auth_with_comfirmed_user) { create(:authorization, :github, user: create(:user, :confirmed)) }
      given!(:auth_with_uncomfirmed_user) { create(:authorization, :github, user: create(:user)) }

      background do
        clear_emails
      end

      describe 'if user exists' do
        describe 'if user confirmed' do
          before do
            OmniAuth.config.mock_auth[:github][:uid] = auth_with_comfirmed_user.uid
            OmniAuth.config.mock_auth[:github][:info][:email] = auth_with_comfirmed_user.user.email
            click_on 'Sign in with GitHub'
          end

          scenario 'sign in' do
            expect(page).to have_content auth_with_comfirmed_user.user.email
          end
        end

        describe 'if user not confirmed' do
          before do
            OmniAuth.config.mock_auth[:github][:uid] = auth_with_uncomfirmed_user.uid
            OmniAuth.config.mock_auth[:github][:info][:email] = auth_with_uncomfirmed_user.user.email
            click_on 'Sign in with GitHub'
          end

          scenario 'Notice user about mail confirmation' do
            expect(page).to have_content 'You need to confirm your email'
          end
        end
      end
    end
  end
end
