require 'rails_helper'

shared_examples_for 'subscribed' do
  let(:user) { create(:user) }

  before do
    login user
  end

  describe 'PATCH #subscribe' do
    describe 'if user is not subscribed' do
      let(:object) { create(controller.controller_name.classify.downcase.to_sym) }

      it "it adds subscriber" do
        expect { patch :subscribe, params: { id: object.id }, format: :js }.to change(object.subscribers, :count).by(1)
      end

      it "it adds subscriptions to user" do
        expect { patch :subscribe, params: { id: object.id }, format: :js }.to change(user.subscriptions, :count).by(1)
      end
    end

    describe 'if user is subscribed' do
      let!(:subscription) { create(:subscription, "for_#{controller.controller_name.classify.downcase}".to_sym, user: user) }
      let(:object) { subscription.subscribable }

      it "it deletes subscriber" do
        expect { patch :subscribe, params: { id:  object.id }, format: :js }.to change(object.subscribers, :count).by(-1)
      end

      it "it deletes subscriptions to user" do
        expect { patch :subscribe, params: { id:  object.id }, format: :js }.to change(user.subscriptions, :count).by(-1)
      end
    end
  end
end
