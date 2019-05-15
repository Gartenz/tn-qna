require 'rails_helper'

RSpec.describe AdditionalSignupsController, type: :controller do
  let(:user) { create(:user, :with_auth) }

  before do
    sign_in user
  end

  describe 'Patch #finish_signup' do
    context 'if user exists' do
      let(:unconfimred_user) { create(:user, confirmed_at: nil) }
      let!(:confirmed_user) { create(:user, :with_auth, confirmed_at: Time.now.utc) }

      it 'deletes temporary user' do
        expect { patch :finish_signup, params: { id: user.id, user: { email: confirmed_user.email } } }.to change(User,:count).by(-1)
      end

      it 'adds authorization to existed user' do
        expect { patch :finish_signup, params: { id: user.id, user: { email: confirmed_user.email } } }.to change(confirmed_user.authorizations,:count).by(1)
      end

      context 'user confirmed' do
        it 'signed in if user confirmed' do
          patch :finish_signup, params: { id: user.id, user: { email: confirmed_user.email } }
          expect(controller.current_user).to eq confirmed_user
        end
      end

      context 'user does not confirmed' do
        it 'sends confirmation email if user is not confirmed' do
          patch :finish_signup, params: { id: user.id, user: { email: unconfimred_user.email } }

          open_letter(unconfimred_user.email)

          expect(unconfimred_user.confirmed?).to be_truthy
        end
      end

      it 'redirects to root_path' do
        patch :finish_signup, params: { id: confirmed_user.id, user: { email: confirmed_user.email } }
        expect(response).to redirect_to root_path
      end
    end

    context 'if user does not exissts' do
      it 'updates email of current user'
      it 'sends confirmation email'
    end
  end
end
