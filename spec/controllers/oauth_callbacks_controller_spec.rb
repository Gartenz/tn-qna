require 'rails_helper'

RSpec.describe OauthCallbacksController, type: :controller do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe 'Github' do
    let(:oauth_data) { OmniAuth::AuthHash.new(provider: 'github', uid: '123456', info: { email: nil }) }

    before do
      allow(request.env).to receive(:[]).and_call_original
      allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
    end

    it 'finds user from oauth data' do
      expect(User).to receive(:find_for_oauth).with(oauth_data)
      get :github
    end

    context 'user exists' do
      let(:unconfirmed_user) { create(:user) }
      let(:confirmed_user) { create(:user, :confirmed) }

      context 'user confirmed' do
        before do
          allow(User).to receive(:find_for_oauth).and_return(confirmed_user)
          get :github
        end

        it 'login user' do
          expect(subject.current_user).to eq confirmed_user
        end

        it 'redirects too root_path' do
          expect(response).to redirect_to root_path
        end
      end

      context 'user does not confirmed' do
        before do
          allow(User).to receive(:find_for_oauth).and_return(unconfirmed_user)
          get :github
        end

        it 'redirects to root path' do
          expect(response).to redirect_to root_path
        end
      end
    end

    context 'user does not exists' do
      before do
        allow(User).to receive(:find_for_oauth)
        get :github
      end

      it 'redirects to add email page' do
        expect(response).to redirect_to add_email_signup_path
      end

      it 'does not login user' do
        expect(subject.current_user).to_not be
      end
    end
  end

  describe 'Vkontakte' do
    let(:oauth_data) { OmniAuth::AuthHash.new(provider: 'vkontakte', uid: '123456', info: { email: nil }) }

    before do
      allow(request.env).to receive(:[]).and_call_original
      allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
    end

    it 'finds user from oauth data' do
      expect(User).to receive(:find_for_oauth).with(oauth_data)
      get :vkontakte
    end

    context 'user exists' do
      let(:unconfirmed_user) { create(:user) }
      let(:confirmed_user) { create(:user, :confirmed) }

      context 'user confirmed' do
        before do
          allow(User).to receive(:find_for_oauth).and_return(confirmed_user)
          get :vkontakte
        end

        it 'login user' do
          expect(subject.current_user).to eq confirmed_user
        end

        it 'redirects too root_path' do
          expect(response).to redirect_to root_path
        end
      end

      context 'user does not confirmed' do
        before do
          allow(User).to receive(:find_for_oauth).and_return(unconfirmed_user)
          get :vkontakte
        end

        it 'redirects to root path' do
          expect(response).to redirect_to root_path
        end
      end
    end

    context 'user does not exists' do
      before do
        allow(User).to receive(:find_for_oauth)
        get :vkontakte
      end

      it 'redirects to add email page' do
        expect(response).to redirect_to add_email_signup_path
      end

      it 'does not login user' do
        expect(subject.current_user).to_not be
      end
    end
  end
end
