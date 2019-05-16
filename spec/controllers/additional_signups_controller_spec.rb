require 'rails_helper'

RSpec.describe AdditionalSignupsController, type: :controller do
  let(:user) { create(:user, :with_auth) }

  before do
    sign_in user
  end

  describe 'Patch #finish_signup' do
    context 'if user exists' do
      let!(:confirmed_user) { create(:user, :with_auth, confirmed_at: Time.now.utc) }
      let!(:unconfirmed_user) { create(:user) }

      it 'deletes temporary user' do
        expect { patch :finish_signup, params: { user: { email: confirmed_user.email } } }.to change(User,:count).by(-1)
      end

      it 'adds authorization to existed user' do
        expect { patch :finish_signup, params: { user: { email: confirmed_user.email } } }.to change(confirmed_user.authorizations,:count).by(1)
      end

      context 'user confirmed' do
        it 'signed in if user confirmed' do
          patch :finish_signup, params: { user: { email: confirmed_user.email } }
          expect(controller.current_user).to eq confirmed_user
        end
      end

      context 'user does not confirmed' do
        it 'sends confirmation email if user is not confirmed' do
          expect_any_instance_of(User).to receive(:send_confirmation_instructions)

          patch :finish_signup, params: { user: { email: unconfirmed_user.email } }
        end
      end

      it 'redirects to root_path' do
        patch :finish_signup, params: { user: { email: confirmed_user.email } }

        expect(response).to redirect_to root_path
      end
    end

    context 'if user does not exissts' do
      let(:unknown_email) { "some_unknownemail_#{rand(0..10000)}@tests.com"}

      it 'updates email of current user' do
        patch :finish_signup, params: { user: { email: unknown_email } }
        user.reload
        expect(user.email).to eq unknown_email
      end

      it 'sends confirmation email' do
        expect_any_instance_of(User).to receive(:send_confirmation_instructions)

        patch :finish_signup, params: { user: { email: unknown_email } }
      end
    end
  end
end
