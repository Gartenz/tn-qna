require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should belong_to(:user) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  describe '#best_answer returns' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, question: question, best: true) }

    it 'answer if question have best anwer' do
      expect(question.best_answer).to eq answer
    end

    it 'nil if question does not have best answer' do
      question = create(:question, user: user)
      expect(question.best_answer).to eq nil
    end
  end

  describe '#mark_best' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:old_best) { create(:answer, question: question, best: true) }

    it 'updates best answer of question with new  best answer' do
      new_best = create(:answer, question: question)
      question.mark_best(new_best)

      old_best.reload
      new_best.reload

      expect(old_best.best).to eq false
      expect(new_best.best).to eq true
    end

    it 'did not updates if answer do not belong to question' do
      answer = create(:answer)
      question.mark_best(answer)

      old_best.reload

      expect(old_best.best).to eq true
    end
  end
end
