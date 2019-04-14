require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  describe "DELETE #destroy" do
    let(:user) { create(:user) }
    let!(:question) { create(:question, :with_file, user: user) }

    context 'User as author' do
      before { login(question.user) }

      it 'tries to deletes question' do
        expect { delete :destroy, params: { id: question.files.first }, format: :js }.to change(question.files, :count).by(-1)
      end

      it 'redirects to index view' do
        delete :destroy, params: { id: question.files.first }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'User as not an author' do
      before do
        user = create(:user)
        login(user)
      end

      it ' tries to deletes question' do
        expect { delete :destroy, params: { id: question.files.first }, format: :js }.to_not change(question.files, :count)
      end

      it 'redirects to index view' do
        delete :destroy, params: { id: question.files.first }, format: :js
        expect(response).to render_template :destroy
      end
    end

    it 'Unauthenticated user tries to delete question' do
      delete :destroy, params: { id: question.files.first }
      expect(response).to redirect_to new_user_session_path
    end
  end

end
