require 'rails_helper'

RSpec.describe Services::NotifySubscribers do
  let(:subscription) { create(:subscription, :for_question) }
  let(:answer) { create(:answer, question: subscription.subscribable) }

  it 'sends mail to all subscribed users' do
    subscription.subscribable.subscribers.each { |user| expect(SubscriptionMailer).to receive(:send_answer).with(answer, user).and_call_original }
    subject.send_emails(answer)
  end
end
