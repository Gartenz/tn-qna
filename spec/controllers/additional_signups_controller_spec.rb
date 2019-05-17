require 'rails_helper'

RSpec.describe AdditionalSignupsController, type: :controller do
  describe 'Patch #finish_signup' do
    context 'if user exists' do
      let!(:confirmed_user) { create(:user, :with_auth, :confirmed) }
      let!(:unconfirmed_user) { create(:user) }

      context 'user confirmed' do
        it 'signs in' do
          patch :finish_signup, params: { user: { email: confirmed_user.email } }
          expect(controller.current_user).to eq confirmed_user
        end

        it 'redirects to root_path' do
          patch :finish_signup, params: { user: { email: unconfirmed_user.email } }

          expect(response).to redirect_to root_path
        end
      end

      context 'user does not confirmed' do
        it 'redirects to root_path' do
          patch :finish_signup, params: { user: { email: unconfirmed_user.email } }

          expect(response).to redirect_to root_path
        end
      end
    end

    context 'if user does not exissts' do
      let(:unknown_email) { "some_unknownemail_#{rand(0..10000)}@tests.com"}

      it 'Creates new user' do
        expect { patch :finish_signup, params: { user: { email: unknown_email } } }.to change(User, :count).by(1)
      end

      it 'sends confirmation email' do
        expect_any_instance_of(User).to receive(:send_confirmation_instructions)

        patch :finish_signup, params: { user: { email: unknown_email } }
      end
    end
  end
end
