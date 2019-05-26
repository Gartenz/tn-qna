require 'rails_helper'

shared_examples_for 'subscribable' do
  let(:model) { described_class }
  let(:object) { create(model.to_s.underscore.to_sym)}
  let(:user) { create(:user) }

  describe '#subscribed?' do
    it 'returns true if user already subscribed' do
      object.subscribers.create(user: user)

      expect(object.subscribed?(user)).to eq true
    end

    it 'returns false if user is not subscribed' do
      expect(object.subscribed?(user)).to eq false
    end
  end

  describe '#subscribe' do
    it 'creates subscription if user is not subscribed' do
      expect{ object.subscribe(user) }.to change(Subscription, :count).by(1)
    end

    it 'deletes subscription if user subscribed' do
      object.subscribe(user)

      expect{ object.subscribe(user) }.to change(Subscription, :count).by(-1)
    end
  end
end
