require 'rails_helper'

shared_examples_for 'votable' do
  let(:model) { described_class }
  let(:object) { create(model.to_s.underscore.to_sym)}
  let(:user) { create(:user) }

  describe '#voted?' do
    it 'return true if user already voted' do
      object.votes.create(user: user)

      expect(object.voted?(user)).to eq true
    end

    it 'return false if user not vote yet' do
      expect(object.voted?(user)).to eq false
    end
  end

  it '#vote' do
    expect { object.votes.create(user: user) }.to change(Vote, :count).by(1)
  end
  it '#cancel_vote' do
    object.votes.create(user: user)

    expect { object.cancel_vote(user) }.to change(Vote, :count).by(-1)
  end

  it '#score' do
    object.votes.create(user: user)

    expect(object.score).to eq 1
  end
end
