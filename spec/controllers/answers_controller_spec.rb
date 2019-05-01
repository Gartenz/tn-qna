require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:question) { create(:question, :with_reward, user: user) }
  let!(:answer) { create(:answer, question: question, user: user) }

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'add answer to question' do
        expect{ post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js }.to change(question.answers, :count).by(1)
      end

      it 'redirect to question' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js
        expect(response).to render_template :create
      end

      it 'checks if current user owns this answer' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js
        expect(assigns(:exposed_answer).user).to eq user
      end
    end

    context 'with invalid attributes' do
      it 'does now save the question' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js }.to_not change(Answer, :count)
      end

      it 're-render new view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid), format: :js }
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }

    context 'with valid attributes' do
      it 'changes answer attributes' do
        patch :update, params: { question_id: question, id: answer, answer: { body: '123' } }, format: :js
        answer.reload

        expect(answer.body).to eq '123'
      end

      it 'redirect to question view' do
        patch :update, params: { question_id: question, id: answer, answer: attributes_for(:answer) }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      it 'does not change question' do
        expect do
          patch :update, params: { question_id: question, id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        end.to_not change(answer, :body)
      end

      it 're-render edit view' do
        patch :update, params: { question_id: question, id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :update
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'User tries to delete his own answer' do
      before { login(answer.user) }

      it 'deletes answer from DB' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to change(Answer, :count).by(-1)
      end

      it 'redirects to index view' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'User tries to delete not his own answer' do
      before do
        user = create(:user)
        login(user)
      end

      it 'not deletes answer from DB' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to_not change(Answer, :count)
      end

      it 'redirects to index view' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to render_template :destroy
      end
    end

    it 'Unauthenticated user tries to delete answer' do
      delete :destroy, params: { id: answer }
      expect(response).to redirect_to new_user_session_path
    end
  end

  describe 'PATCH #best' do
    context 'Authenticated user' do
      let!(:old_best) { create(:answer, question: question, best: true) }

      context 'as author of question tries to mark best answer' do
        before do
          login user
        end

        it 'updates answer params in DB' do
          patch :best, params: { id: answer }, format: :js

          old_best.reload
          answer.reload

          expect(old_best.best).to eq false
          expect(answer.best).to eq true
        end

        it 'assigns reward to user' do
          expect { patch :best, params: { id: answer }, format: :js }.to change(answer.user.rewards, :count).by(1)
        end

        it 'renders view' do
          patch :best, params: { id: answer }, format: :js

          expect(response).to render_template :best
        end
      end

      context 'as not an author of question tries to mark best answer' do
        let(:other_user) { create(:user) }

        before do
          login other_user
          patch :best, params: { id: answer }, format: :js
        end

        it 'not updates params in DB' do
          old_best.reload
          answer.reload

          expect(old_best.best).to_not eq false
          expect(answer.best).to_not eq true
        end

        it 'renders view' do
          expect(response).to render_template :best
        end
      end
    end

    it 'Unauthenticated user tries to mark answer' do
      patch :best, params: { id: answer }

      expect(response).to redirect_to new_user_session_path
    end
  end

  describe 'PATCH #vote_up' do
    before do
      login another_user
    end

    it 'change rating up of answer' do
      expect { patch :vote_up, params: { id: answer , format: :json } }.to change(answer.votes, :count).to(1)
    end
  end
  describe 'PATCH #vote_down' do
    before do
      login another_user
    end

    it 'change rating down of answer' do
      expect { patch :vote_down, params: { id: answer , format: :json } }.to change(answer.votes, :count).to(1)
    end
  end
  describe 'PATCH #vote_cancel' do
    before do
      login another_user
      patch :vote_down, params: { id: answer , format: :json }
    end

    it 'cancel voting of answer' do
      expect { patch :vote_up, params: { id: answer , format: :json } }.to_not change(answer.votes, :count)
    end
  end
end
