require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves new question to database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end

      it 'redirect to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to assigns(:exposed_question)
      end

      it 'checks if current user owns this question' do
        post :create, params: { question: attributes_for(:question) }
        expect(assigns(:exposed_question).user).to eq user
      end
    end

    context 'with invalid attributes' do
      it 'does now save the question' do
        expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
      end

      it 're-render new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    let(:question) { create(:question, user: user) }

    before { login(question.user) }

    context 'with valid attributes' do
      it 'assigns requested question to @question' do
        patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
        expect(assigns(:exposed_question)).to eq question
      end

      it 'changes question attibutes' do
        patch :update, params: { id: question, question: { title: '123', body: '123' } }, format: :js
        question.reload

        expect(question.title).to eq '123'
        expect(question.body).to eq '123'
      end

      it 'redirect to show view' do
        patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do

      it 'does not change question' do
        old_title = question.title

        patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js
        question.reload

        expect(question.title).to eq old_title
        expect(question.body).to eq 'MyText'
      end

      it 're-render edit view' do
        patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js
        expect(response).to render_template :update
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:question) { create(:question, user: user) }

    context 'User tries to delete his own question' do
      before { login(question.user) }

      it 'deletes question' do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end

      it 'redirects to index view' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'User tries to delete not his own question' do
      before do
        user = create(:user)
        login(user)
      end

      it 'deletes question' do
        expect { delete :destroy, params: { id: question }, format: :js }.to_not change(Question, :count)
      end

      it 'redirects to index view' do
        delete :destroy, params: { id: question }, format: :js
        expect(response).to render_template 'questions/show'
      end
    end

    it 'Unauthenticated user tries to delete question' do
      delete :destroy, params: { id: question }
      expect(response).to redirect_to new_user_session_path
    end
  end
end
