require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:answers) }
  it { should have_many(:questions) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe 'if user author of question' do
    let(:author_user) { create(:user) }
    let(:user) { create(:user) }
    let(:question) { create(:question, user: author_user) }

    it 'Returns true if question belongs to user' do
      expect(author_user).to be_author_of(question)
    end

    it 'Returns false if question does not belongs to user' do
      expect(user).to_not be_author_of(question)
    end
  end

  describe 'if user author of answer' do
    let(:author_user) { create(:user) }
    let(:user) { create(:user) }
    let(:answer) { create(:answer, user: author_user) }

    it 'Returns true if question belongs to user' do
      expect(author_user).to be_author_of(answer)
    end

    it 'Returns false if question does not belongs to user' do
      expect(user).to_not be_author_of(answer)
    end
  end
end
