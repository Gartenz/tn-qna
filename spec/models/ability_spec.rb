require 'rails_helper'
describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:other_user) { create(:user) }
    let(:question) { create(:question, user: user, answers: create_list(:answer, 1))}
    let(:other_question) { create(:question, answers: create_list(:answer, 1))}

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }

    it { should be_able_to :update, create(:question, user: user) }
    it { should_not be_able_to :update, create(:question, user: other_user) }
    it { should be_able_to :update, create(:answer, user: user) }
    it { should_not be_able_to :update, create(:answer, user: other_user) }

    it { should be_able_to :destroy, create(:question, user: user) }
    it { should_not be_able_to :destroy, create(:question, user: other_user) }
    it { should be_able_to :destroy, create(:answer, user: user) }
    it { should_not be_able_to :destroy, create(:answer, user: other_user) }

    it { should be_able_to :vote, create(:answer) }
    it { should_not be_able_to :vote, create(:answer, user: user) }
    it { should be_able_to :vote, create(:question) }
    it { should_not be_able_to :vote, create(:question, user: user) }

    it { should be_able_to :best, question.answers.first }
    it { should_not be_able_to :best, other_question.answers.first }
  end
end
