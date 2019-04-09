require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'add answer to question' do
        expect{ post :create, params: { question_id: question, answer: attributes_for(:answer) } }.to change(question.answers, :count).by(1)
      end

      it 'redirect to question' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }
        expect(response).to redirect_to question
      end

      it 'checks if current user owns this answer' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }
        expect(question.answers.last.user).to eq user
      end
    end

    context 'with invalid attributes' do
      it 'does now save the question' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) } }.to_not change(Answer, :count)
      end

      it 're-render new view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }
        expect(response).to render_template 'questions/show'
      end
    end
  end

  describe 'PATCH #update' do
    let(:answer) { create(:answer, question:question, user: user) }
    before { login(user) }

    context 'with valid attributes' do
      it 'changes answer attributes' do
        patch :update, params: { question_id: question, id: answer, answer: { body: '123' } }
        answer.reload

        expect(answer.body).to eq '123'
      end

      it 'redirect to question view' do
        patch :update, params: { question_id: question, id: answer, answer: attributes_for(:answer) }
        expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      it 'does not change question' do
        old_body = answer.body
        patch :update, params: { question_id: question, id: answer, answer: attributes_for(:answer, :invalid) }
        answer.reload

        expect(answer.body).to eq old_body
      end

      it 're-render edit view' do
        patch :update, params: { question_id: question, id: answer, answer: attributes_for(:answer, :invalid) }
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer, question: question, user: user) }

    context 'User tries to delete his own answer' do
      before { login(answer.user) }

      it 'deletes answer from DB' do
        expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(-1)
      end

      it 'redirects to index view' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to answer.question
      end
    end

    context 'User tries to delete not his own answer' do
      before do
        user = create(:user)
        login(user)
      end

      it 'not deletes answer from DB' do
        expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(0)
      end

      it 'redirects to index view' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to answer.question
      end
    end

    it 'Unauthenticated user tries to delete answer' do
      delete :destroy, params: { id: answer }
      expect(response).to redirect_to new_user_session_path
    end
  end
end
