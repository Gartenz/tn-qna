require 'rails_helper'

RSpec.describe Services::NotifySubscribers do
  let!(:question) { create(:question) }
  let!(:answer) { create(:answer, question: question) }
  let(:users) { create_list(:user, 3) }

  it 'sends mail to all subscribed users' do
    users.each { |user| question.subscribe(user) }
    question.subscribers.each { |user| expect(SubscriptionMailer).to receive(:send_answer).with(answer, user).and_call_original }
    subject.send_emails(answer)
  end

  it 'does not send email to non subscribed users' do
    expect { subject.send_emails(answer) }.to_not change(ActionMailer::Base.deliveries, :count)
  end
end
