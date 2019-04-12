require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should belong_to(:user) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  describe '#best_answer returns' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, question: question, best: true)}

    it 'answer if question have best anwer' do
      expect(question.best_answer).to eq answer
    end

    it 'nil if question does not have best answer' do
      question = create(:question, user: user)
      expect(question.best_answer).to eq nil
    end
  end
end
