require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:question) { create(:question) }
  let(:user) { create(:user) }

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'add comment to question' do
        expect{ post :create, params: { question_id: question, comment: attributes_for(:comment), commentable: 'question' }, format: :js }.to change(question.comments, :count).by(1)
      end

      it 'redirect to question' do
        post :create, params: { question_id: question, comment: attributes_for(:comment), commentable: 'question'}, format: :js
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does now save the question' do
        expect { post :create, params: { question_id: question, comment: attributes_for(:comment, :invalid), commentable: 'question' }, format: :js }.to_not change(Comment, :count)
      end

      it 're-render new view' do
        post :create, params: { question_id: question, comment: attributes_for(:comment, :invalid), commentable: 'question', format: :js }
        expect(response).to render_template :create
      end
    end
  end
end
