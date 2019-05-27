require "rails_helper"

RSpec.describe SubscriptionMailer, type: :mailer do
  describe "notify" do
    let(:user) { create(:user) }
    let(:mail) { SubscriptionMailer.notify }

    it "renders the headers" do
      expect(mail.subject).to eq("New notifications on subscribed resource")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body"
  end

end
