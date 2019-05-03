require 'rails_helper'

shared_examples_for 'voted' do
  let(:object) { create(controller.controller_name.classify.downcase.to_sym) }
  let(:another_user) { create(:user) }

  before do
    login another_user
  end

  describe 'PATCH #vote_up' do
    it 'change rating up of answer' do
      expect { patch :vote_up, params: { id: object , format: :json } }.to change(object.votes, :count).to(1)
    end
  end

  describe 'PATCH #vote_down' do
    it 'change rating down of answer' do
      expect { patch :vote_down, params: { id: object , format: :json } }.to change(object.votes, :count).to(1)
    end
  end

  describe 'PATCH #vote_cancel' do
    before do
      patch :vote_down, params: { id: object , format: :json }
    end

    it 'cancel voting of answer' do
      expect { patch :vote_up, params: { id: object , format: :json } }.to_not change(object.votes, :count)
    end
  end
end
